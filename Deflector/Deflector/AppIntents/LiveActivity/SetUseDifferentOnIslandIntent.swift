//
//  SetUseDifferentOnIslandIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/26.
//

import AppIntents

struct SetUseDifferentOnIslandIntent: AppIntent {
    static let title: LocalizedStringResource = "Set 'Use Different Shortcuts on Dynamic Island'"
    static let isDiscoverable = true
    static var supportedModes: IntentModes = .background
    
    enum TurnEnum: String, AppEnum {
        case turn
        case toggle
        
        static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Operation")
        static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
            .turn: "Turn",
            .toggle: "Toggle"
        ]
    }
    
    @Parameter(title: "Operation", default: .turn)
    var operation: TurnEnum?
    
    @Parameter(title: "State", default: false)
    var state: Bool
    
    static var parameterSummary: some ParameterSummary {
        When(\.$operation, .equalTo, .turn) {
            Summary("\(\.$operation) 'Use Different Shortcuts on Dynamic Island' \(\.$state)")
        } otherwise: {
            Summary("\(\.$operation) 'Use Different Shortcuts on Dynamic Island'")
        }
    }
    
    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<Bool> {
        switch operation {
        case .turn:
            UserSettings.shared.liveActivityUseDifferentOnIsland = state
        case .toggle:
            UserSettings.shared.liveActivityUseDifferentOnIsland.toggle()
        default:
            break
        }
        
        return .result(value: UserSettings.shared.liveActivityUseDifferentOnIsland)
    }
}
