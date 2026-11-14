//
//  AddTimerIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/11/04.
//

import AppIntents

struct AddTimerIntent: AppIntent {
    static let title: LocalizedStringResource = "Add Timer"
    static let description: LocalizedStringResource = "Schedule a shortcut to run later."
    static let isDiscoverable = true
    static var supportedModes: IntentModes = .background

    @Parameter(title: "Shortcut Name")
    var shortcutName: String

    @Parameter(title: "Date & Time", kind: .dateTime)
    var fireDate: Date

    enum PerformError: LocalizedError {
        case shortcutNameIsEmpty
        case notificationsDisabled
        case schedule(TimerModel.ScheduleError)
        case failed(String)

        var errorDescription: String? {
            switch self {
            case .shortcutNameIsEmpty:
                return String(localized: "Shortcut name is not set.")
            case .notificationsDisabled:
                return String(localized: "Notifications are not allowed. Please complete the first setup.")
            case .schedule(let error):
                return String(localized: error.localizedStringResource)
            case .failed(let message):
                return String(localized: "Failed to schedule the timer: \(message)")
            }
        }
    }

    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        guard !shortcutName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw PerformError.shortcutNameIsEmpty
        }

        let settings = await UserNotificationSupport.notificationSettings()
        guard UserNotificationSupport.isAlertAvailable(settings: settings) else {
            throw PerformError.notificationsDisabled
        }

        do {
            let uuid = try await TimerModel.shared.schedule(shortcutName: shortcutName, fireDate: fireDate)
            return .result(value: uuid)
        } catch let error as TimerModel.ScheduleError {
            throw PerformError.schedule(error)
        } catch {
            throw PerformError.failed(error.localizedDescription)
        }
    }
}
