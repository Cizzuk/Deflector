//
//  ImportLiveActivityShortcutsJSONIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/26.
//

import AppIntents

struct ImportLiveActivityShortcutsJSONIntent: AppIntent {
    static let title: LocalizedStringResource = "Import Live Activity Shortcuts from JSON"
    static let description: LocalizedStringResource = "If you import a single shortcut, it will be added. If you import an array of multiple shortcuts, it will overwrite existing shortcuts."
    static let isDiscoverable = true
    static var supportedModes: IntentModes = .background
    
    @Parameter(title: "JSON")
    var json: String
    
    @Parameter(title: "Import to Dynamic Island", default: false)
    var dynamicIsland: Bool
    
    @MainActor
    func perform() async throws -> some IntentResult {
        let decoder = JSONDecoder()
        var newButtons = dynamicIsland ? UserSettings.shared.liveActivityIslandButtons : UserSettings.shared.liveActivityButtons
        
        if let buttons = try? decoder.decode([DeflectorActivityButton].self, from: Data(json.utf8)) {
            newButtons = buttons
        } else {
            let button = try decoder.decode(DeflectorActivityButton.self, from: Data(json.utf8))
            newButtons.append(button)
        }
        
        if dynamicIsland {
            UserSettings.shared.liveActivityIslandButtons = newButtons
        } else {
            UserSettings.shared.liveActivityButtons = newButtons
        }
        
        return .result()
    }
}
