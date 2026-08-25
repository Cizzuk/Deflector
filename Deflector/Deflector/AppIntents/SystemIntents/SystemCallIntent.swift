//
//  SystemCallIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/24.
//

import AppIntents

struct SystemCallIntent: LiveActivityIntent {
    static let title: LocalizedStringResource = "System Call Intent"
    static let isDiscoverable = true
    static var supportedModes: IntentModes = .background
    
    @Parameter(title: "Argument")
    var argument: String
    
    @MainActor
    func perform() async throws -> some IntentResult {
        SystemCallSupport.handleSystemCall(argument)
        return .result()
    }
}
