//
//  SystemAutomationDetectIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/25.
//

import AppIntents
import UserNotifications

struct SystemAutomationDetectIntent: LiveActivityIntent {
    static let title: LocalizedStringResource = "System Automation Detect Intent"
    static let isDiscoverable = false
    static var supportedModes: IntentModes = .background
    
    @Parameter(title: "Version")
    var version: Int
    
    func perform() async throws -> some IntentResult {
        Task.detached {
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        }
        return .result()
    }
}
