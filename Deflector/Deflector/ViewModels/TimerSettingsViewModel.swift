//
//  TimerSettingsViewModel.swift
//  Deflector
//
//  Created by Cizzuk on 2026/11/03.
//

import Combine
import SwiftUI

class TimerSettingsViewModel: ObservableObject {
    enum Mode: Hashable {
        case duration
        case date
    }

    private static let defaultDuration = DateComponents(hour: 0, minute: 5, second: 0)

    @Published var errorMessage: LocalizedStringResource?
    @Published var isScheduling = false

    @Published var shortcutName = ""
    @Published var mode: Mode = .duration
    @Published var duration = defaultDuration
    @Published var date: Date
    @Published var dateRange: ClosedRange<Date>

    init() {
        let selection = Self.dateSelection()
        date = selection.date
        dateRange = selection.range
    }

    func durationInterval(from now: Date = .now) -> TimeInterval {
        guard let end = Calendar.current.date(byAdding: duration, to: now) else { return 0 }
        return end.timeIntervalSince(now)
    }

    var canSchedule: Bool {
        guard !shortcutName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, !isScheduling else { return false }
        switch mode {
        case .duration:
            return durationInterval() >= 1
        case .date:
            return resolvedFireDate() != nil
        }
    }

    func prepareEditor() {
        shortcutName = ""
        mode = .duration
        duration = Self.defaultDuration
        errorMessage = nil

        let selection = Self.dateSelection()
        date = selection.date
        dateRange = selection.range
    }

    func resolvedFireDate(now: Date = .now) -> Date? {
        guard mode == .date, TimerModel.isSchedulable(date, from: now) else { return nil }
        return date
    }

    func schedule() async -> Bool {
        let name = shortcutName
        let interval = durationInterval()
        let fireDate = date

        guard canSchedule else { return false }

        isScheduling = true
        defer { isScheduling = false }

        let settings = await UserNotificationSupport.notificationSettings()
        guard UserNotificationSupport.isAlertAvailable(settings: settings) else {
            return fail("Notifications are not allowed. Please complete the first setup.")
        }

        do {
            switch mode {
            case .duration:
                try await TimerModel.shared.schedule(shortcutName: name, interval: interval)
            case .date:
                try await TimerModel.shared.schedule(shortcutName: name, fireDate: fireDate)
            }
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            return true
        } catch let error as TimerModel.ScheduleError {
            return fail(error.localizedStringResource)
        } catch {
            return fail("Failed to schedule the timer: \(error.localizedDescription)")
        }
    }

    private static func dateSelection(from now: Date = .now) -> (date: Date, range: ClosedRange<Date>) {
        let calendar = Calendar.current
        let limit = TimerModel.latestFireDate(from: now)
        let candidate = min(now.addingTimeInterval(60 * 60), limit)
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: candidate)
        components.second = 0
        let date = calendar.date(from: components) ?? candidate
        return (date, now...limit)
    }

    private func fail(_ message: LocalizedStringResource) -> Bool {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        errorMessage = message
        return false
    }
}
