//
//  FeatureAvailability.swift
//  Deflector
//
//  Created by Cizzuk on 2026/11/08.
//

class FeatureAvailability {
    static func isInputAvailable() -> Bool {
        return isAvailable(minimumVersion: 2)
    }

    private static func isAvailable(minimumVersion: Int) -> Bool {
        if UserSettings.shared.deflectorAutomationVersion >= minimumVersion {
            return true
        }
        return false
    }
}
