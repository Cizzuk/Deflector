//
//  RemoveLiveActivityShortcutIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/26.
//

import AppIntents

struct RemoveLiveActivityShortcutIntent: AppIntent {
    static let title: LocalizedStringResource = "Remove Shortcut from Live Activity"
    static let description: LocalizedStringResource = "Removes all shortcuts from Live Activity with matching names."
    static let isDiscoverable = true
    static var supportedModes: IntentModes = .background
    
    @Parameter(title: "Shortcut Name")
    var shortcutName: String
    
    @Parameter(title: "Remove from Dynamic Island", default: false)
    var dynamicIsland: Bool
    
    @MainActor
    func perform() async throws -> some IntentResult {
        if dynamicIsland {
            UserSettings.shared.liveActivityIslandButtons.removeAll(where: { $0.shortcutName == shortcutName })
        } else {
            UserSettings.shared.liveActivityButtons.removeAll(where: { $0.shortcutName == shortcutName })
        }
        
        return .result()
    }
}
