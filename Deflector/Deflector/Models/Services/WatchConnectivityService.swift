//
//  WatchConnectivityService.swift
//  Deflector
//
//  Created by Cizzuk on 2026/09/27.
//

import Combine
import WatchConnectivity

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
        DispatchQueue.main.async {
            self.activationState = self.session.activationState
            self.isPaired = self.session.isPaired
            self.isWatchAppInstalled = self.session.isWatchAppInstalled
        }
    }
    
    private func handleReceivedMethod(_ method: WCMessage.Method) {
        switch method {
        case .requestApplicationContext:
            resendApplicationContext()
            
        case .deflection(let shortcutName):
            Task { await DeflectionService.shared.runShortcut(shortcutName: shortcutName) }
            
        case .requestAllShortcuts:
            guard applicationContext.allowShowAllShortcuts else {
                let message = WCMessage(method: .responseAllShortcuts(shortcuts: []))
                session.sendMessage(message.toDictionary(), replyHandler: nil)
                return
            }
            
            Task {
                await DeviceShortcutsSupport.callDeviceShortcuts()
                let notifications = NotificationCenter.default.notifications(named: .deviceShortcutsReceived)
                for await notification in notifications {
                    let shortcuts = DeviceShortcutsSupport.parseDeviceShortcutsNotification(notification) ?? []
                    let message = WCMessage(method: .responseAllShortcuts(shortcuts: shortcuts))
                    session.sendMessage(message.toDictionary(), replyHandler: nil)
                    break
                }
            }
            
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
    
    // MARK: - Application Context
    
    var applicationContext: WCAppContext {
        if let context = try? WCAppContext(session.applicationContext) {
            return context
        }
        return WCAppContext()
    }
    
    func updateApplicationContext(_ context: WCAppContext) throws {
        try session.updateApplicationContext(context.toDictionary())
    }
    
    private func resendApplicationContext() {
        let context = session.applicationContext
        try? session.updateApplicationContext([:]) // Refresh
        try? session.updateApplicationContext(context)
    }
}
