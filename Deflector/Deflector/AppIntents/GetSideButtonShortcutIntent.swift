//
//  GetSideButtonShortcutIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/26.
//

import AppIntents

struct GetSideButtonShortcutIntent: AppIntent {
    static let title: LocalizedStringResource = "Get Side Button Shortcut Name"
    static let isDiscoverable = true
    static var supportedModes: IntentModes = .background
    
    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        return .result(value: UserSettings.shared.sideButtonShortcutName)
    }
}
