//
//  SystemAutomationDetectIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/25.
//

import AppIntents
import UserNotifications

extension Notification.Name {
    static let deflectorAutomationDetected = Notification.Name("deflectorAutomationDetected")
}

struct SystemAutomationDetectIntent: AppIntent {
    static let title: LocalizedStringResource = "System Automation Detect Intent"
    #if DEBUG
    static let isDiscoverable = true
    #else
    static let isDiscoverable = false
    #endif
    static var supportedModes: IntentModes = .background
    
    @Parameter(title: "Version")
    var version: Int
    
    @MainActor
    func perform() async throws -> some IntentResult {
        NotificationCenter.default.post(
            name: .deflectorAutomationDetected,
            object: nil,
            userInfo: ["version": version]
        )
        
        Task.detached {
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        }
        
        return .result()
    }
}
