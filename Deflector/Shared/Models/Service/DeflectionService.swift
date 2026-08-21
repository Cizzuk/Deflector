//
//  DeflectionService.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/21.
//

import UserNotifications

class DeflectionService {
    static let shared = DeflectionService()
    private init() { }
    
    var lastDeflectionTime: Date?
    
    func sendDeflectionNotification(name: String) async {
        // Sent within 0.5 seconds will be ignored
        if let lastDeflectionTime {
            let distance = lastDeflectionTime.distance(to: Date())
            if distance < 0.5 { return }
        }
        lastDeflectionTime = Date()
        
        let content = UNMutableNotificationContent()
        content.title = String(localized: "Deflection")
        content.body = name
        content.sound = .none
        content.interruptionLevel = .timeSensitive
        
        await UserNotificationSupport.sendNotification(content: content)
    }
    
    func sendDeflectionErrorNotification(reason: LocalizedStringResource? = nil) async {
        let content = UNMutableNotificationContent()
        content.title = String(localized: "Deflection failed")
        if let reason {
            content.body = String(localized: reason)
        }
        content.sound = .none
        content.interruptionLevel = .timeSensitive
        
        await UserNotificationSupport.sendNotification(content: content)
    }
}
