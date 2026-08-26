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
    
    func sendNotification(name: String) async {
        // Sent within 0.5 seconds will be ignored
        if let lastDeflectionTime {
            let distance = lastDeflectionTime.distance(to: Date())
            if distance < 0.5 { return }
        }
        lastDeflectionTime = Date()
        
        let content = UNMutableNotificationContent()
        content.title = "Deflection"
        content.body = name
        content.sound = .none
        content.interruptionLevel = .timeSensitive
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        
        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print("Failed to add notification request: \(error)")
        }
    }
    
    func sendErrorNotification(reason: LocalizedStringResource? = nil) async {
        let subtitle = String(localized: "Deflection failed")
        
        let body: String?
        if let reason {
            body = String(localized: reason)
        } else {
            body = nil
        }
        
        await UserNotificationSupport.addNotificationToDisplay(
            subtitle: subtitle,
            body: body
        )
    }
}
