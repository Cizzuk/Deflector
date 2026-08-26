//
//  ShortcutPickerSupport.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/24.
//

import UserNotifications

extension Notification.Name {
    static let shortcutWasPicked = Notification.Name("shortcutWasPicked")
}

class ShortcutPickerSupport {
    static func handleShortcutPick(_ shortcutName: String) {
        NotificationCenter.default.post(name: .shortcutWasPicked, object: nil, userInfo: ["shortcutName": shortcutName])
    }
    
    static func callShortcutPicker(prompt: LocalizedStringResource? = nil) async {
        let content = UNMutableNotificationContent()
        content.title = "Shortcut Picker"
        content.sound = .none
        content.interruptionLevel = .timeSensitive
        
        if let prompt { content.body = String(localized: prompt) }
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        
        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print("Failed to add notification request: \(error)")
        }
    }
}
