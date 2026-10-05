//
//  WatchConnectivityService.swift
//  Deflector
//
//  Created by Cizzuk on 2026/09/27.
//

import Combine
import WatchConnectivity

extension Notification.Name {
    static let watchConnectivityApplicationContextDidChange = Notification.Name("watchConnectivityApplicationContextDidChange")
}

final class WatchConnectivityService: NSObject, ObservableObject {
    static let shared = WatchConnectivityService()
    
    private let session = WCSession.default
    
    @Published private(set) var activationState: WCSessionActivationState = .notActivated
    @Published private(set) var isPaired = false
    @Published private(set) var isWatchAppInstalled = false
    
    override private init() {
        super.init()
        guard DeviceInfo.isWatchSupported else { return }
        
        session.delegate = self
        session.activate()
        updateSessionState()
    }
    
    private func updateSessionState() {
        Task { @MainActor in
            activationState = session.activationState
            isPaired = session.isPaired
            isWatchAppInstalled = session.isWatchAppInstalled
        }
    }
    
    // MARK: - Application Context
    
    var applicationContext: WCAppContext {
        if let context = try? WCAppContext(session.applicationContext) {
            return context
        }
        return WCAppContext()
    }
    
    func updateApplicationContext(_ context: WCAppContext) throws {
        guard context != applicationContext else { return }
        try session.updateApplicationContext(context.toDictionary())
        NotificationCenter.default.post(name: .watchConnectivityApplicationContextDidChange, object: nil)
    }
    
    private func resendApplicationContext() {
        let context = session.applicationContext
        try? session.updateApplicationContext([:]) // Refresh
        try? session.updateApplicationContext(context)
    }
    
    // MARK: - Device Shortcuts Notification Observer
    
    private var waitingAutomationDetectedNotification = false
    private var waitingDeviceShortcutsNotification = false
    
    func postNotification(_ notification: Notification) {
        guard activationState == .activated else { return }
        
        switch notification.name {
        case .deflectorAutomationDetected:
            guard waitingAutomationDetectedNotification else { return }
            waitingAutomationDetectedNotification = false
            
            let message = WCMessage(method: .automationDetected)
            session.sendMessage(message.toDictionary(), replyHandler: nil)
            
        case .deviceShortcutsReceived:
            guard waitingDeviceShortcutsNotification else { return }
            waitingDeviceShortcutsNotification = false
            
            guard let shortcuts = DeviceShortcutsSupport.parseDeviceShortcutsNotification(notification) else { return }
            let message = WCMessage(method: .responseAllShortcuts(shortcuts: shortcuts))
            session.sendMessage(message.toDictionary(), replyHandler: nil)

        default: break
        }
    }
    
    // MARK: - Message Handling
    
    private func handleReceivedMethod(_ method: WCMessage.Method) {
        switch method {
        case .requestApplicationContext:
            resendApplicationContext()
            
        case .deflection(let shortcutName):
            waitingAutomationDetectedNotification = true
            Task { await DeflectionService.shared.runShortcut(shortcutName: shortcutName) }
            
        case .requestAllShortcuts:
            guard applicationContext.allowShowAllShortcuts else {
                let message = WCMessage(method: .responseAllShortcuts(shortcuts: []))
                session.sendMessage(message.toDictionary(), replyHandler: nil)
                return
            }
            
            waitingDeviceShortcutsNotification = true
            Task { await DeviceShortcutsSupport.callDeviceShortcuts() }
            
        default:
            break
        }
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
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        updateSessionState()
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        updateSessionState()
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        updateSessionState()
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        updateSessionState()
        session.activate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard let wcMessage = try? WCMessage(message) else { return }
        handleReceivedMethod(wcMessage.method)
    }
}
