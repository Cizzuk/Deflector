//
//  EndDeflectorActivityIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/16.
//

import AppIntents

struct EndDeflectorActivityIntent: LiveActivityIntent {
    static let title: LocalizedStringResource = "End Deflector Live Activity"
    static let isDiscoverable = true
    static var supportedModes: IntentModes = .background
    
    @MainActor
    func perform() async throws -> some IntentResult {
        DeflectorActivitySupport.endAll()
        return .result()
    }
}
