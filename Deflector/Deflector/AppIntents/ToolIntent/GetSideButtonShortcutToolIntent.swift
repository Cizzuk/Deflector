//
//  GetSideButtonShortcutToolIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/11/14.
//

import AppIntents

@available(iOS 27.3, *)
@AppIntent(.tool)
struct GetSideButtonShortcutToolIntent: AppIntent {
    static let title: LocalizedStringResource = "Get Side Button Shortcut Name"
    static let isDiscoverable = false
    static var supportedModes: IntentModes = .background

    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        guard UserSettings.shared.isSettingsAvailable() else {
            throw IntentUserSettingsError.loadSettingsFailed
        }

        return .result(value: UserSettings.shared.sideButtonShortcutName)
    }
}
