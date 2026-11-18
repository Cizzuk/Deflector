//
//  GetAllTimersIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/11/04.
//

import AppIntents

@AppIntent(.tool)
struct GetAllTimersIntent: AppIntent {
    static let title: LocalizedStringResource = "Get All Timers"
    static let description: LocalizedStringResource = "Returns a JSON list of the timer IDs, shortcut names, and execution times as Unix time."
    static let isDiscoverable = true
    static var supportedModes: IntentModes = .background

    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<[String]> {
        await TimerModel.shared.refresh()

        let schedules = TimerModel.shared.timers

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        encoder.outputFormatting = .prettyPrinted

        let jsonStrings: [String] = schedules.compactMap { schedule in
            guard let jsonData = try? encoder.encode(schedule),
                let jsonString = String(data: jsonData, encoding: .utf8)
            else { return nil }
            return jsonString
        }

        return .result(value: jsonStrings)
    }
}
