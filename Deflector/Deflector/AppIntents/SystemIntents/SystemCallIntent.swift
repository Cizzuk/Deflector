//
//  SystemCallIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/24.
//

import AppIntents

struct SystemCallIntent: LiveActivityIntent {
    static let title: LocalizedStringResource = "System Call Intent"
    #if DEBUG
    static let isDiscoverable = true
    #else
    static let isDiscoverable = false
    #endif
    static var supportedModes: IntentModes = .background
    
    @Parameter(title: "Argument")
    var argument: String
    
    @MainActor
    func perform() async throws -> some IntentResult {
        SystemCallSupport.handleSystemCall(argument)
        return .result()
    }
}
