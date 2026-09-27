//
//  MainViewModel.swift
//  Deflector
//
//  Created by Cizzuk on 2026/09/27.
//

import Combine
import SwiftUI
import WatchConnectivity

class MainViewModel: ObservableObject {
    private let watchConnectivity = WatchConnectivityService.shared
    
    @Published var errorMessage: LocalizedStringResource? = nil
    
    func onChange(scenePhase: ScenePhase) {
        switch scenePhase {
        case .active:
            watchConnectivity.activateSessionIfDeactivated()
            watchConnectivity.sendResendApplicationContextRequestIfNeeded()
        case .inactive:
            break
        case .background:
            break
        @unknown default:
            break
        }
    }
    
    func sendDeflection(_ shortcutName: String) {
        watchConnectivity.sendDeflection(shortcutName: shortcutName) { error in
            let nsError = error as NSError
            print("Error sending deflection: \(error.localizedDescription)")
            
            switch nsError {
            case WCError.sessionNotActivated:
                self.errorMessage = "Failed to send the shortcut because the session with the iPhone is not activated."
            case WCError.notReachable:
                self.errorMessage = "Failed to send the shortcut because Deflector couldn't connect to the iPhone."
            case WCError.payloadTooLarge:
                self.errorMessage = "Failed to send the shortcut because the data of the shortcut is too large."
            case WCError.messageReplyFailed:
                self.errorMessage = "Failed to send the shortcut because the iPhone couldn't reply."
            case WCError.deliveryFailed:
                self.errorMessage = "Failed to send the shortcut because the system couldn't deliver the data."
            case WCError.insufficientSpace:
                self.errorMessage = "Failed to send the shortcut because the iPhone doesn't have enough available storage."
            case WCError.sessionInactive:
                self.errorMessage = "Failed to send the shortcut because the session with the iPhone is inactive."
            case WCError.transferTimedOut:
                self.errorMessage = "Failed to send the shortcut because the connection to the iPhone timed out."
            default:
                self.errorMessage = "Failed to send the shortcut: \(error.localizedDescription)"
            }
        }
    }
}
