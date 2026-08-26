//
//  SystemShortcutPickerIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/26.
//

import AppIntents

struct SystemShortcutPickerIntent: LiveActivityIntent {
    static let title: LocalizedStringResource = "System Shortcut Picker Intent"
    static let isDiscoverable = false
    static var supportedModes: IntentModes = .background
    
    @Parameter(title: "Shortcut Name")
    var shortcutName: String
    
    @MainActor
    func perform() async throws -> some IntentResult {
        ShortcutPickerSupport.handleShortcutPick(shortcutName)
        return .result()
    }
}
