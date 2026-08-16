//
//  StartDeflectorActivityIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/16.
//

import AppIntents

struct StartDeflectorActivityIntent: LiveActivityIntent {
    static let title: LocalizedStringResource = "Start Deflector Live Activity"
    static let isDiscoverable = true
    static var supportedModes: IntentModes = .background
    
    @MainActor
    func perform() async throws -> some IntentResult {
        try DeflectorActivitySupport.start()
        return .result()
    }
}
