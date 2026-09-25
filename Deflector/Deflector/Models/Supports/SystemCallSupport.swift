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
        case refreshDeflectorActivity = "Refresh Deflector Activity"
    }
    
    static func handleSystemCall(_ argument: String) {
        switch SystemCallArgs(rawValue: argument) {
        case .pingTest:
            NotificationCenter.default.post(name: .pingTestReceived, object: nil)
        case .refreshDeflectorActivity:
            try? DeflectorActivitySupport.refresh()
        default:
            break
        }
    }
    
    static func addSystemCall(_ argument: SystemCallArgs, trigger: UNNotificationTrigger? = nil) async {
        let content = UNMutableNotificationContent()
        content.title = "System Call"
        content.body = argument.rawValue
        content.sound = .none
        content.interruptionLevel = .timeSensitive
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print("Failed to add notification request: \(error)")
        }
    }
    
    static func cancelSystemCalls(_ argument: SystemCallArgs) async {
        let notificationCenter = UNUserNotificationCenter.current()
        let pendingRequests = await notificationCenter.pendingNotificationRequests()
        
        for request in pendingRequests {
            if request.content.title == "System Call" && request.content.body == argument.rawValue {
                notificationCenter.removePendingNotificationRequests(withIdentifiers: [request.identifier])
            }
        }
    }
}
