//
//  WatchConnectivityService.swift
//  Deflector Watch
//
//  Created by Cizzuk on 2026/09/27.
//

import Combine
import WatchConnectivity
import WidgetKit

extension Notification.Name {
    static let deviceShortcutsReceived = Notification.Name("deviceShortcutsReceived")
}

final class WatchConnectivityService: NSObject, ObservableObject {
    static let shared = WatchConnectivityService()
    
    private let session = WCSession.default
    
    @Published private(set) var activationState: WCSessionActivationState = .notActivated
    @Published private(set) var iOSDeviceNeedsUnlockAfterRebootForReachability: Bool = false
    @Published private(set) var isReachable: Bool = false
    
    private var deflectionAfterReachable: (() -> Void)?
    
    @Published private(set) var receivedApplicationContext: WCAppContext = WCAppContext.loadLastContext()
    @Published private(set) var sentDeflectionShortcut: String?
    
    override private init() {
        super.init()
        guard WCSession.isSupported() else { return }
        
        session.delegate = self
        session.activate()
        updateSessionState()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            // If receivedApplicationContext couldn't be received, request it again after 1s.
            self?.sendResendApplicationContextRequestIfNeeded()
        }
    }
    
    private func updateSessionState() {
        Task { @MainActor in
            activationState = session.activationState
            iOSDeviceNeedsUnlockAfterRebootForReachability = session.iOSDeviceNeedsUnlockAfterRebootForReachability
            isReachable = session.isReachable
        }
    }
    
    private func updateReceivedApplicationContext(
        _ receivedApplicationContext: [String: Any]? = nil
    ) {
        Task { @MainActor in
            let newContext = receivedApplicationContext ?? session.receivedApplicationContext
            guard let wcAppContext = try? WCAppContext(newContext) else { return }
            
            self.receivedApplicationContext = wcAppContext
            
            wcAppContext.saveLastContext()
            WidgetCenter.shared.reloadTimelines(
                ofKind: "net.cizzuk.deflector.watchkitapp.WidgetExtension.DeflectionWidget"
            )
        }
    }
    
    private func handleReceivedMethod(_ method: WCMessage.Method) {
        switch method {
        case .automationDetected:
            Task { @MainActor in
                sentDeflectionShortcut = nil
            }
            
        case .responseAllShortcuts(shortcuts: let shortcuts):
            Task { @MainActor in
                NotificationCenter.default.post(name: .deviceShortcutsReceived, object: nil, userInfo: ["shortcuts": shortcuts])
            }
            
        default:
            break
        }
    }
    
    // MARK: - Public Methods
    
    func activateSessionIfDeactivated() {
        guard activationState != .activated else { return }
        session.activate()
    }
    
    func sendResendApplicationContextRequestIfNeeded() {
        guard activationState == .activated,
              session.isReachable,
              receivedApplicationContext.favoriteShortcuts.isEmpty
                else { return }
        let message = WCMessage(method: .requestApplicationContext)
        session.sendMessage(message.toDictionary(), replyHandler: nil)
    }
    
    func sendDeflection(shortcutName: String, errorHandler: ((Error) -> Void)? = nil) {
        if sentDeflectionShortcut == nil || deflectionAfterReachable != nil {
            sentDeflectionShortcut = shortcutName
        }
        
        let message = WCMessage(method: .deflection(shortcutName: shortcutName))
        
        let task = {
            self.session.sendMessage(message.toDictionary(), replyHandler: nil) { error in
                errorHandler?(error)
                Task { @MainActor in
                    self.sentDeflectionShortcut = nil
                }
            }
        }
        
        if session.isReachable {
            task()
        } else {
            deflectionAfterReachable = task
        }
    }
    
    func sendAllShortcutsRequest(errorHandler: ((Error) -> Void)? = nil) {
        guard receivedApplicationContext.allowShowAllShortcuts else { return }
        
        let message = WCMessage(method: .requestAllShortcuts)
        session.sendMessage(
            message.toDictionary(),
            replyHandler: nil,
            errorHandler: errorHandler
        )
    }
}

// MARK: - WCSessionDelegate
extension WatchConnectivityService: WCSessionDelegate {
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: (any Error)?
    ) {
        updateSessionState()
        sendResendApplicationContextRequestIfNeeded()
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        updateSessionState()
        sendResendApplicationContextRequestIfNeeded()
        
        if session.isReachable {
            deflectionAfterReachable?()
            deflectionAfterReachable = nil
        }
    }
    
    func session(
        _ session: WCSession,
        didReceiveApplicationContext applicationContext: [String : Any]
    ) {
        updateReceivedApplicationContext(applicationContext)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard let wcMessage = try? WCMessage(message) else { return }
        handleReceivedMethod(wcMessage.method)
    }
}
