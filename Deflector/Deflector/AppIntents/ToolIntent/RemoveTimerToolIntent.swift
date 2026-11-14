//
//  RemoveTimerToolIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/11/14.
//

import AppIntents

@available(iOS 27.3, *)
@AppIntent(.tool)
struct RemoveTimerToolIntent: AppIntent {
    static let title: LocalizedStringResource = "Remove Timer"
    static let description: LocalizedStringResource = "Removes the timer matching the ID. The ID can be obtained from the shortcut or the context menu in the app."
    static let isDiscoverable = false
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
