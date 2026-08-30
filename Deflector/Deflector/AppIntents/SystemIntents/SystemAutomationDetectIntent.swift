//
//  SystemAutomationDetectIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/25.
//

import AppIntents
import UserNotifications

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
    
    func perform() async throws -> some IntentResult {
        Task.detached {
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        }
        return .result()
    }
}
