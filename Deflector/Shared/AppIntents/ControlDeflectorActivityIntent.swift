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
    
    init() { }
    
    init(control: ControlEnum) {
        self.control = control
    }
    
    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<Bool> {
        #if !EXTENSION
        switch control {
        case .start:
            try await DeflectorActivitySupport.start()
        case .end:
            try? await DeflectorActivitySupport.start()
            await DeflectorActivitySupport.endAll()
        case .toggle:
            if DeflectorActivitySupport.isActive() {
                try? await DeflectorActivitySupport.start()
                await DeflectorActivitySupport.endAll()
            } else {
                try await DeflectorActivitySupport.start()
            }
        }
        
        return .result(value: DeflectorActivitySupport.isActive())
        #else
        return .result(value: false)
        #endif
    }
}
