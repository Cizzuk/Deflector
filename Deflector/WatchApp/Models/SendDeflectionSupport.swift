//
//  SendDeflectionSupport.swift
//  Deflector Watch
//
//  Created by Cizzuk on 2026/09/27.
//

import WatchConnectivity

class SendDeflectionSupport {
    static func makeErrorMessage(error: any Error) -> LocalizedStringResource {
        let nsError = error as NSError
        
        switch nsError {
        case WCError.sessionNotActivated:
            return "Failed to send the shortcut because the session with the iPhone is not activated."
        case WCError.notReachable:
            return "Failed to send the shortcut because Deflector couldn't connect to the iPhone."
        case WCError.payloadTooLarge:
            return "Failed to send the shortcut because the data of the shortcut is too large."
        case WCError.messageReplyFailed:
            return "Failed to send the shortcut because the iPhone couldn't reply."
        case WCError.deliveryFailed:
            return "Failed to send the shortcut because the system couldn't deliver the data."
        case WCError.insufficientSpace:
            return "Failed to send the shortcut because the iPhone doesn't have enough available storage."
        case WCError.sessionInactive:
            return "Failed to send the shortcut because the session with the iPhone is inactive."
        case WCError.transferTimedOut:
            return "Failed to send the shortcut because the connection to the iPhone timed out."
        default:
            return "Failed to send the shortcut: \(error.localizedDescription)"
        }
    }
}
