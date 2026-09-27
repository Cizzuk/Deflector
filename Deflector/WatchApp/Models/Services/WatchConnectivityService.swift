//
//  WatchConnectivityService.swift
//  Deflector Watch
//
//  Created by Cizzuk on 2026/09/27.
//

import Combine
import WatchConnectivity

final class WatchConnectivityService: NSObject, ObservableObject {
    static let shared = WatchConnectivityService()
    
    private let session = WCSession.default
    
    @Published private(set) var activationState: WCSessionActivationState = .notActivated
    @Published private(set) var iOSDeviceNeedsUnlockAfterRebootForReachability: Bool = false
    @Published private(set) var isReachable: Bool = false
    
    @Published private(set) var receivedApplicationContext: WCAppContext = WCAppContext()
    
    override private init() {
        super.init()
        guard WCSession.isSupported() else { return }
        
        session.delegate = self
        session.activate()
        updateSessionState()
    }
    
    private func updateSessionState() {
        DispatchQueue.main.async {
            self.activationState = self.session.activationState
            self.iOSDeviceNeedsUnlockAfterRebootForReachability = self.session.iOSDeviceNeedsUnlockAfterRebootForReachability
            self.isReachable = self.session.isReachable
        }
    }
    
    private func updateReceivedApplicationContext(
        _ receivedApplicationContext: [String: Any]? = nil
    ) {
        let newContext = receivedApplicationContext ?? session.receivedApplicationContext
        let wcAppContext = (try? WCAppContext(newContext)) ?? WCAppContext()
        DispatchQueue.main.async {
            self.receivedApplicationContext = wcAppContext
        }
    }
    
    private func sendResendApplicationContextRequest() {
        guard activationState == .activated, isReachable else { return }
        let message = WCMessage(method: .requestApplicationContext)
        session.sendMessage(message.toDictionary(), replyHandler: nil)
    }
    
    // MARK: - Public Methods
    
    func sendDeflection(shortcutName: String, errorHandler: ((Error) -> Void)? = nil) {
        let message = WCMessage(method: .deflection(shortcutName: shortcutName))
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
        sendResendApplicationContextRequest()
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        updateSessionState()
        sendResendApplicationContextRequest()
    }
    
    func session(
        _ session: WCSession,
        didReceiveApplicationContext applicationContext: [String : Any]
    ) {
        updateReceivedApplicationContext(applicationContext)
    }
}
