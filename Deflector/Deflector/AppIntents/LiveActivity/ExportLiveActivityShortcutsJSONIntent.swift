//
//  ExportLiveActivityShortcutsJSONIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/26.
//

import AppIntents

struct ExportLiveActivityShortcutsJSONIntent: AppIntent {
    static let title: LocalizedStringResource = "Export Live Activity Shortcuts as JSON"
    static let isDiscoverable = true
    static var supportedModes: IntentModes = .background
    
    @Parameter(title: "Export from Dynamic Island", default: false)
    var dynamicIsland: Bool
    
    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        let buttons = dynamicIsland ? UserSettings.shared.liveActivityIslandButtons : UserSettings.shared.liveActivityButtons
        
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(buttons)
        let jsonString = String(data: jsonData, encoding: .utf8)
        
        return .result(value: jsonString ?? "")
    }
}
