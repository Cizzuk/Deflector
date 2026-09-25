//
//  DeviceShortcutsSupport.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/24.
//

import UserNotifications

extension Notification.Name {
    static let deviceShortcutsReceived = Notification.Name("deviceShortcutsReceived")
}

class DeviceShortcutsSupport {
    static func handleDeviceShortcuts(_ shortcuts: [String]) {
        NotificationCenter.default.post(name: .deviceShortcutsReceived, object: nil, userInfo: ["shortcuts": shortcuts])
    }
    
    static func callDeviceShortcuts() async {
        let content = UNMutableNotificationContent()
        content.title = "Device Shortcuts"
        content.sound = .none
        content.interruptionLevel = .timeSensitive
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        
        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print("Failed to add notification request: \(error)")
        }
    }
}
