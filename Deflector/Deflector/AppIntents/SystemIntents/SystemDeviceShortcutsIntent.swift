//
//  SystemDeviceShortcutsIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/26.
//

import AppIntents

struct SystemDeviceShortcutsIntent: AppIntent {
    static let title: LocalizedStringResource = "System Device Shortcuts Intent"
    #if DEBUG
    static let isDiscoverable = true
    #else
    static let isDiscoverable = false
    #endif
    static var supportedModes: IntentModes = .background
    
    @Parameter(title: "Shortcuts")
    var shortcuts: [String]
    
    static var parameterSummary: some ParameterSummary {
        Summary("System Device Shortcuts Intent \(\.$shortcuts)")
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        DeviceShortcutsSupport.handleDeviceShortcuts(shortcuts)
        return .result()
    }
}
