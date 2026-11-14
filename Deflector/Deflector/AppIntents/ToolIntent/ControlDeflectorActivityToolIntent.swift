//
//  ControlDeflectorActivityToolIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/11/14.
//

import AppIntents

@available(iOS 27.3, *)
@AppIntent(.tool)
struct ControlDeflectorActivityToolIntent: LiveActivityIntent {
    static let title: LocalizedStringResource = "Control Deflector Live Activity"
    static let isDiscoverable = false
    static var supportedModes: IntentModes = .background

    @Parameter(title: "Control", default: .start)
    var control: ControlDeflectorActivityIntent.ControlEnum

    static var parameterSummary: some ParameterSummary {
        Summary("\(\.$control) Deflector Live Activity")
    }

    init() {}

    init(control: ControlDeflectorActivityIntent.ControlEnum) {
        self.control = control
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        func startActivity() async throws {
            guard UserSettings.shared.isSettingsAvailable() else {
                throw IntentUserSettingsError.loadSettingsFailed
            }
            try await DeflectorActivitySupport.start()
        }

        func endActivity() async {
            await DeflectorActivitySupport.endAll()
        }

        switch control {
        case .start:
            try await startActivity()
        case .end:
            await endActivity()
        case .toggle:
            if DeflectorActivitySupport.isActive() {
                await endActivity()
            } else {
                try await startActivity()
            }
        }

        return .result(value: DeflectorActivitySupport.isActive())
    }
}
