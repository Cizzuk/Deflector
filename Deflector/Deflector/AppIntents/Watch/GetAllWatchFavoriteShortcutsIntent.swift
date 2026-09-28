//
//  GetAllWatchFavoriteShortcutsIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/26.
//

import AppIntents

struct GetAllWatchFavoriteShortcutsIntent: AppIntent {
    static let title: LocalizedStringResource = "Get All Favorite Shortcuts for Apple Watch"
    static let isDiscoverable = true
    static var supportedModes: IntentModes = .background
    
    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<[String]> {
        let favoriteShortcuts = WatchConnectivityService.shared.applicationContext.favoriteShortcuts
        var shortcuts: [String] = []
        
        favoriteShortcuts.forEach { shortcut in
            shortcuts.append(shortcut.shortcutName)
        }
        
        return .result(value: shortcuts)
    }
}
