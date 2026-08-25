//
//  SystemCallSupport.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/24.
//

import UserNotifications

extension Notification.Name {
    static let pingTestReceived = Notification.Name("pingTestReceived")
}

class SystemCallSupport {
    enum SystemCallArgs: String {
        case pingTest = "Ping Test"
        case startDeflectorActivity = "Start Deflector Activity"
    }
    
    static func handleSystemCall(_ argument: String) {
        switch SystemCallArgs(rawValue: argument) {
        case .pingTest:
            NotificationCenter.default.post(name: .pingTestReceived, object: nil)
        case .startDeflectorActivity:
            try? DeflectorActivitySupport.start()
        default:
            break
        }
    }
    
    static func sendSystemCall(_ argument: SystemCallArgs) async {
        let content = UNMutableNotificationContent()
        content.title = "System Call"
        content.body = argument.rawValue
        content.sound = .none
        content.interruptionLevel = .timeSensitive
        
        await UserNotificationSupport.sendNotification(content: content)
    }
}
