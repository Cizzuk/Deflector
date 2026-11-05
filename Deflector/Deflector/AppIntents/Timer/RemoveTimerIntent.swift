//
//  RemoveTimerIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/11/04.
//

import AppIntents

@AppIntent(.tool)
struct RemoveTimerIntent: AppIntent {
    static let title: LocalizedStringResource = "Remove Timer"
    static let description: LocalizedStringResource = "Removes the timer matching the ID. The ID can be obtained from the shortcut or the context menu in the app."
    static let isDiscoverable = true
    static var supportedModes: IntentModes = .background

    @Parameter(title: "ID")
    var id: String

    @MainActor
    func perform() async throws -> some IntentResult {
        await TimerModel.shared.refresh()
        await TimerModel.shared.remove(ids: [id])
        return .result()
    }
}
