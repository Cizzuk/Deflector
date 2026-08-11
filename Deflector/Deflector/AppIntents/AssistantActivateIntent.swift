//
//  AssistantActivateIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/11.
//

import AppIntents
import UserNotifications

@AppIntent(schema: .assistant.activate)
struct AssistantActivateIntent: AppIntent {
    static let title: LocalizedStringResource = "Side Button Deflector"
    static let isDiscoverable = false
    static var supportedModes: IntentModes = .foreground
    
    init() {
        Self.supportedModes = .background
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        let name = UserSettings.shared.sideButtonShortcutName
        
        if name.isEmpty {
            await UserNotificationSupport.sendDeflectionErrorNotification(reason: "No shortcut is set for the Side Button.")
        } else {
            await UserNotificationSupport.sendDeflectionNotification(name: name)
        }
        
        return .result()
    }
}
