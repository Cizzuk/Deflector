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
    
    @Published private(set) var isPaired = false
    @Published private(set) var isWatchAppInstalled = false
    @Published private(set) var isReachable = false
    @Published private(set) var activationState: WCSessionActivationState = .notActivated
    
    override private init() {
        super.init()
        guard DeviceInfo.isWatchSupported else { return }
        
        session.delegate = self
        session.activate()
        updateSessionState()
    }
    
    private func updateSessionState() {
        DispatchQueue.main.async {
            self.isPaired = self.session.isPaired
            self.isWatchAppInstalled = self.session.isWatchAppInstalled
            self.isReachable = self.session.isReachable
            self.activationState = self.session.activationState
        }
    }
}

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
    
    func session(
        _ session: WCSession,
        didReceiveMessage message: [String : Any],
        replyHandler: @escaping ([String : Any]) -> Void
    ) {
        
    }
}
