//
//  UserNotificationSupport.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/11.
//

import UserNotifications

class UserNotificationSupport {
    static func notificationSettings() async -> UNNotificationSettings {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        return settings
    }
    
    static func isAvailable() async -> Bool {
        let authorizationStatus = await notificationSettings().authorizationStatus
        
        if authorizationStatus == .notDetermined || authorizationStatus == .authorized {
            return true
        }
        
        return false
    }
    
    static func requestAuthorization() async -> Bool {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        
        if settings.authorizationStatus == .notDetermined {
            do {
                try await center.requestAuthorization(options: [.alert])
                return await requestAuthorization()
            } catch {
                print("Failed to request notification authorization: \(error)")
                return false
            }
        }

        if settings.authorizationStatus == .authorized {
            return true
        }

        return false
    }
    
    static func addNotificationToDisplay(
        subtitle: String? = nil,
        body: String? = nil,
        trigger: UNNotificationTrigger? = nil
    ) async {
        let content = UNMutableNotificationContent()
        content.title = "Notification"
        content.sound = .none
        content.interruptionLevel = .timeSensitive
        
        if let subtitle { content.subtitle = subtitle }
        if let body { content.body = body }
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print("Failed to add notification request: \(error)")
        }
    }
}
