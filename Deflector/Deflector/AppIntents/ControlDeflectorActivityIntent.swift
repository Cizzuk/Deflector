//
//  ControlDeflectorActivityIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/16.
//

import AppIntents

struct ControlDeflectorActivityIntent: LiveActivityIntent {
    static let title: LocalizedStringResource = "Control Deflector Live Activity"
    static let isDiscoverable = true
    static var supportedModes: IntentModes = .background
    
    enum ControlEnum: String, AppEnum {
        case start, end, toggle
        
        static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Control")
        static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
            .start: "Start",
            .end: "End",
            .toggle: "Toggle"
        ]
    }
    
    @Parameter(title: "Control", default: .start)
    var control: ControlEnum
    
    static var parameterSummary: some ParameterSummary {
        Summary("\(\.$control) Deflector Live Activity")
    }
    
    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<Bool> {
        switch control {
        case .start:
            try DeflectorActivitySupport.start()
        case .end:
            DeflectorActivitySupport.endAll()
        case .toggle:
            if DeflectorActivitySupport.isActive() {
                DeflectorActivitySupport.endAll()
            } else {
                try DeflectorActivitySupport.start()
            }
        }
        
        return .result(value: DeflectorActivitySupport.isActive())
    }
}
