//
//  SetSideButtonShortcutToolIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/11/14.
//

import AppIntents

@available(iOS 27.3, *)
@AppIntent(.tool)
struct SetSideButtonShortcutToolIntent: AppIntent {
    static let title: LocalizedStringResource = "Set Side Button Shortcut"
    static let isDiscoverable = false
    static var supportedModes: IntentModes = .background

    @Parameter(title: "Shortcut Name")
    var shortcutName: String

    static var parameterSummary: some ParameterSummary {
        Summary("Set Side Button Shortcut to \(\.$shortcutName)")
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        guard UserSettings.shared.isSettingsAvailable() else {
            throw IntentUserSettingsError.loadSettingsFailed
        }

        UserSettings.shared.sideButtonShortcutName = shortcutName
        return .result()
    }
}
