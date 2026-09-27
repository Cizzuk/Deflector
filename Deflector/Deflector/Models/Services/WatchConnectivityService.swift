//
//  WatchConnectivityService.swift
//  Deflector
//
//  Created by Cizzuk on 2026/09/27.
//

import Combine
import WatchConnectivity

class WatchConnectivityService: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = WatchConnectivityService()
    
    override private init() {
        super.init()
        guard DeviceInfo.isWatchSupported else { return }
        
        let session = WCSession.default
        session.delegate = self
        session.activate()
    }
    
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: (any Error)?
    ) {
        print("WCSession activated: \(activationState.rawValue)")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) { }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession deactivated")
        WCSession.default.activate()
    }
    
    func session(
        _ session: WCSession,
        didReceiveMessage message: [String : Any],
        replyHandler: @escaping ([String : Any]) -> Void
    ) {
        
    }
}
