//
//  AddLiveActivityShortcutIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/26.
//

import AppIntents

struct AddLiveActivityShortcutIntent: LiveActivityIntent {
    static let title: LocalizedStringResource = "Add Shortcut to Live Activity"
    static let description: LocalizedStringResource = "Adds a shortcut to Live Activity. Adding 5 or more may cause display issues."
    static let isDiscoverable = true
    static var supportedModes: IntentModes = .background
    
    @Parameter(title: "Shortcut Name")
    var shortcutName: String
    
    @Parameter(title: "Symbol", default: "suit.diamond")
    var symbol: String?
    
    @Parameter(title: "Add to Dynamic Island", default: false)
    var dynamicIsland: Bool
    
    @MainActor
    func perform() async throws -> some IntentResult {
        let newButton = DeflectorActivityButton(shortcutName: shortcutName, symbol: symbol ?? "suit.diamond")
        
        if dynamicIsland {
            UserSettings.shared.liveActivityIslandButtons.append(newButton)
        } else {
            UserSettings.shared.liveActivityButtons.append(newButton)
        }
        
        return .result()
    }
}
