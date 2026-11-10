//
//  IntentUserSettingsError.swift
//  Deflector
//
//  Created by Cizzuk on 2026/10/23.
//

import AppIntents

enum IntentUserSettingsError: LocalizedError {
    case loadSettingsFailed

    var errorDescription: String? {
        switch self {
        case .loadSettingsFailed:
            return String(localized: "Failed to load Settings.")
        }
    }
}
