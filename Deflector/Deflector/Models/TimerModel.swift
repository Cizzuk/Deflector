//
//  TimerModel.swift
//  Deflector
//
//  Created by Cizzuk on 2026/11/03.
//

import Combine
import UserNotifications

struct ScheduledTimer: Identifiable, Equatable, Codable {
    let id: String
    let shortcutName: String
    let fireDate: Date
}

final class TimerModel: ObservableObject {
    static let shared = TimerModel()
    static let maxCount = 30

    @Published private(set) var timers: [ScheduledTimer] = []

    private let automationObserver: AnyCancellable

    enum ScheduleError: Error, CustomLocalizedStringResourceConvertible {
        case limitReached
        case invalidDate

        var localizedStringResource: LocalizedStringResource {
            switch self {
            case .limitReached:
                "You can schedule up to \(TimerModel.maxCount) timers."
            case .invalidDate:
                "Set a time within one year from now."
            }
        }
    }

    private enum Keys {
        static let kind = "deflectorTimer"
        static let kindValue = "timer"
        static let fireDate = "deflectorTimerFireDate"
    }

    private init() {
        automationObserver = NotificationCenter.default.publisher(for: .deflectorAutomationDetected)
            .sink { _ in
                Task { await TimerModel.shared.refresh() }
            }
        Task { await refresh() }
    }

    static func latestFireDate(from now: Date = .now) -> Date {
        Calendar.current.date(byAdding: .year, value: 1, to: now)
            ?? now.addingTimeInterval(60 * 60 * 24 * 365)
    }

    static func isSchedulable(_ fireDate: Date, from now: Date = .now) -> Bool {
        fireDate.timeIntervalSince(now) >= 1 && fireDate <= latestFireDate(from: now)
    }

    func refresh() async {
        let requests = await UNUserNotificationCenter.current().pendingNotificationRequests()
        timers = requests.compactMap { Self.scheduledTimer(from: $0) }
            .sorted { ($0.fireDate, $0.id) < ($1.fireDate, $1.id) }
    }

    @discardableResult
    func schedule(shortcutName: String, interval: TimeInterval) async throws -> String {
        let uuid = try await schedule(shortcutName, target: .interval(interval))
        return uuid
    }

    @discardableResult
    func schedule(shortcutName: String, fireDate: Date) async throws -> String {
        let uuid = try await schedule(shortcutName, target: .fireDate(fireDate))
        return uuid
    }

    func remove(ids: [String]) async {
        let requestedIDs = Set(ids)
        let timerIDs = timers.map(\.id).filter(requestedIDs.contains)
        guard !timerIDs.isEmpty else { return }

        timers.removeAll { requestedIDs.contains($0.id) }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: timerIDs)
        await refresh()
    }

    private enum Target {
        case interval(TimeInterval)
        case fireDate(Date)
    }

    private func schedule(_ shortcutName: String, target: Target) async throws -> String {
        await refresh()
        guard timers.count < Self.maxCount else {
            throw ScheduleError.limitReached
        }

        let now = Date()
        let interval: TimeInterval
        let fireDate: Date
        switch target {
        case .interval(let value):
            interval = value
            fireDate = now.addingTimeInterval(value)
        case .fireDate(let value):
            interval = value.timeIntervalSince(now)
            fireDate = value
        }
        guard Self.isSchedulable(fireDate, from: now) else {
            throw ScheduleError.invalidDate
        }

        let uuid = try await DeflectionService.shared.scheduleShortcut(
            shortcutName: shortcutName,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false),
            userInfo: [
                Keys.kind: Keys.kindValue,
                Keys.fireDate: fireDate.timeIntervalSince1970,
            ]
        )

        await refresh()
        return uuid
    }

    private static func scheduledTimer(from request: UNNotificationRequest) -> ScheduledTimer? {
        let userInfo = request.content.userInfo
        guard userInfo[Keys.kind] as? String == Keys.kindValue,
            let fireDate = date(from: userInfo[Keys.fireDate])
        else { return nil }

        let shortcutName = request.content.body
        guard !shortcutName.isEmpty else { return nil }
        return ScheduledTimer(id: request.identifier, shortcutName: shortcutName, fireDate: fireDate)
    }

    private static func date(from value: Any?) -> Date? {
        guard let seconds = (value as? NSNumber)?.doubleValue ?? value as? Double else { return nil }
        return Date(timeIntervalSince1970: seconds)
    }
}
