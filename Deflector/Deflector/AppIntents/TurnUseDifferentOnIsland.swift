//
//  TurnUseDifferentOnIsland.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/26.
//

import AppIntents

struct TurnUseDifferentOnIsland: LiveActivityIntent {
    static let title: LocalizedStringResource = "Turn 'Use Different Shortcuts on Dynamic Island'"
    static let isDiscoverable = true
    static var supportedModes: IntentModes = .background
    
    @Parameter(title: "Setting")
    var setting: Bool
    
    static var parameterSummary: some ParameterSummary {
        Summary("Turn 'Use Different Shortcuts on Dynamic Island' \(\.$setting)")
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        UserSettings.shared.liveActivityUseDifferentOnIsland = setting
        return .result()
    }
}
