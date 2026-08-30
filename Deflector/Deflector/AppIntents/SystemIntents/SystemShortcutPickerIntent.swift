//
//  SystemShortcutPickerIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/26.
//

import AppIntents

struct SystemShortcutPickerIntent: AppIntent {
    static let title: LocalizedStringResource = "System Shortcut Picker Intent"
    #if DEBUG
    static let isDiscoverable = true
    #else
    static let isDiscoverable = false
    #endif
    static var supportedModes: IntentModes = .background
    
    @Parameter(title: "Shortcut Name")
    var shortcutName: String
    
    @MainActor
    func perform() async throws -> some IntentResult {
        ShortcutPickerSupport.handleShortcutPick(shortcutName)
        return .result()
    }
}
