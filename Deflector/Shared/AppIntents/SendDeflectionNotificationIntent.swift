//
//  SendDeflectionNotificationIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/12.
//

import AppIntents

struct SendDeflectionNotificationIntent: AppIntent {
    static let title: LocalizedStringResource = "Send Deflection Notification"
    static let isDiscoverable = false
    static var supportedModes: IntentModes = .background
    
    @Parameter(title: "Shortcut Name")
    var shortcutName: String
    
    init() {}
    init(shortcutName: String) {
        self.shortcutName = shortcutName
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        if shortcutName.isEmpty {
            await DeflectionService.shared.sendErrorNotification(reason: "Shortcut name is not set.")
        } else {
            await DeflectionService.shared.runShortcut(shortcutName: shortcutName)
        }
        
        return .result()
    }
}
