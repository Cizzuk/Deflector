//
//  DeflectorAutomationSupport.swift
//  Deflector
//
//  Created by Cizzuk on 2026/11/08.
//

import Foundation

extension Notification.Name {
    static let automationUpdateRequested = Notification.Name("automationUpdateRequested")
}

class DeflectorAutomationSupport {
    static let automationURL = URL(string: "https://cizz.uk/deflector/automation")!
    static let automationFileURL = URL(string: "https://cizz.uk/deflector/automation/file")!

    enum Feature {
        case input

        var minimumVersion: Int {
            switch self {
            case .input: return 2
            }
        }
    }

    static func isAvailable(_ feature: Feature) -> Bool {
        if UserSettings.shared.deflectorAutomationVersion >= feature.minimumVersion {
            return true
        }
        return false
    }

    static func requestUpdate(_ feature: Feature) {
        let notification = Notification(name: .automationUpdateRequested, object: nil, userInfo: ["version": feature.minimumVersion])
        NotificationCenter.default.post(notification)
    }
}
