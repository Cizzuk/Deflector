//
//  DeflectionService.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/21.
//

import UserNotifications

class DeflectionService {
    static let shared = DeflectionService()
    private init() {}

    var lastDeflectionTime: Date?

    func runShortcut(
        shortcutName: String,
        shortcutInput: String? = nil,
        ignoreCooldown: Bool = false
    ) async {
        // Sent within 0.25s will be ignored
        if !ignoreCooldown, let lastDeflectionTime {
            let distance = lastDeflectionTime.distance(to: Date())
            if distance < 0.25 { return }
        }

        lastDeflectionTime = Date()

        let content = buildDeflectionNotificationContent(
            shortcutName: shortcutName,
            shortcutInput: shortcutInput
        )

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)

        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print("Failed to add notification request: \(error)")
        }
    }

    func scheduleShortcut(
        shortcutName: String,
        shortcutInput: String? = nil,
        trigger: UNNotificationTrigger?,
        userInfo: [AnyHashable: Any] = [:]
    ) async throws -> String {
        let uuid = UUID().uuidString

        let content = buildDeflectionNotificationContent(
            shortcutName: shortcutName,
            shortcutInput: shortcutInput
        )
        content.userInfo = userInfo

        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        try await UNUserNotificationCenter.current().add(request)

        return uuid
    }

    private func buildDeflectionNotificationContent(
        shortcutName: String,
        shortcutInput: String? = nil,
    ) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        if let shortcutInput {
            content.title = "Deflection with Input"
            content.subtitle = shortcutName
            content.body = shortcutInput
        } else {
            content.title = "Deflection"
            content.body = shortcutName
        }
        content.sound = .none
        content.interruptionLevel = .timeSensitive

        return content
    }

    func sendErrorNotification(reason: LocalizedStringResource? = nil) async {
        let subtitle = String(localized: "Deflection failed")

        let body: String?
        if let reason {
            body = String(localized: reason)
        } else {
            body = nil
        }

        await UserNotificationSupport.addNotificationToDisplay(
            subtitle: subtitle,
            body: body
        )
    }
}
