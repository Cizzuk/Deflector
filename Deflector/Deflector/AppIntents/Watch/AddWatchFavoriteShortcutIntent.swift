//
//  AddWatchFavoriteShortcutIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/26.
//

import AppIntents

struct AddWatchFavoriteShortcutIntent: AppIntent {
    static let title: LocalizedStringResource = "Add Favorite Shortcut to Apple Watch"
    static let isDiscoverable = true
    static var supportedModes: IntentModes = .background
    
    @Parameter(title: "Shortcut Name")
    var shortcutName: String
    
    @Parameter(title: "Symbol", description: "Name of the symbol in SF Symbols", default: "square.2.layers.3d.fill")
    var symbol: String?
    
    enum PerformError: LocalizedError {
        case shortcutNameIsEmpty
        
        var errorDescription: String? {
            switch self {
            case .shortcutNameIsEmpty:
                return "Shortcut name cannot be empty."
            }
        }
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        if shortcutName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw PerformError.shortcutNameIsEmpty
        }
        
        var context = WatchConnectivityService.shared.applicationContext
        
        let newShortcut = WCAppContext.FavoriteShortcut(
            shortcutName: shortcutName,
            symbol: symbol ?? defaultShortcutSymbol
        )
        
        if let index = context.favoriteShortcuts.firstIndex(where: { $0.shortcutName == shortcutName }) {
            // If the shortcut already exists, update
            context.favoriteShortcuts[index] = newShortcut
        } else {
            // If the shortcut does not exist, append
            context.favoriteShortcuts.append(newShortcut)
        }
        
        try WatchConnectivityService.shared.updateApplicationContext(context)
        
        return .result()
    }
}
