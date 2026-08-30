//
//  SetSideButtonShortcutIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/26.
//

import AppIntents

struct SetSideButtonShortcutIntent: AppIntent {
    static let title: LocalizedStringResource = "Set Side Button Shortcut"
    static let isDiscoverable = true
    static var supportedModes: IntentModes = .background
    
    @Parameter(title: "Shortcut Name")
    var shortcutName: String
    
    static var parameterSummary: some ParameterSummary {
        Summary("Set Side Button Shortcut to \(\.$shortcutName)")
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        UserSettings.shared.sideButtonShortcutName = shortcutName
        return .result()
    }
}
