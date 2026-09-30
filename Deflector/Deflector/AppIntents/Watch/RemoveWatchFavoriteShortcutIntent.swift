//
//  RemoveWatchFavoriteShortcutIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/26.
//

import AppIntents

struct RemoveWatchFavoriteShortcutIntent: AppIntent {
    static let title: LocalizedStringResource = "Remove Favorite Shortcut from Apple Watch"
    static let isDiscoverable = true
    static var supportedModes: IntentModes = .background
    
    @Parameter(title: "Shortcut Name")
    var shortcutName: String
    
    @MainActor
    func perform() async throws -> some IntentResult {
        var context = WatchConnectivityService.shared.applicationContext
        context.favoriteShortcuts.removeAll(where: { $0.shortcutName == shortcutName })
        
        try WatchConnectivityService.shared.updateApplicationContext(context)
        
        return .result()
    }
}
