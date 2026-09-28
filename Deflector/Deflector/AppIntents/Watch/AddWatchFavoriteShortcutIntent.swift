//
//  AddWatchFavoriteShortcutIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/26.
//

import AppIntents

struct AddWatchFavoriteShortcutIntent: AppIntent {
    static let title: LocalizedStringResource = "Add Favorite Shortcut to Apple Watch"
    static let description: LocalizedStringResource = "Adds a favorite shortcut to Apple Watch. Adding more than 10 shortcuts will fail."
    static let isDiscoverable = true
    static var supportedModes: IntentModes = .background
    
    @Parameter(title: "Shortcut Name")
    var shortcutName: String
    
    @Parameter(title: "Symbol", description: "Name of the symbol in SF Symbols", default: "suit.diamond")
    var symbol: String?
    
    enum PerformError: LocalizedError {
        case shortcutNameIsEmpty
        case limitReached
        
        var errorDescription: String? {
            switch self {
            case .shortcutNameIsEmpty:
                return "Shortcut name cannot be empty."
            case .limitReached:
                return "You have reached the limit of 10 favorite shortcuts on Apple Watch."
            }
        }
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        if shortcutName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw PerformError.shortcutNameIsEmpty
        }
        
        var context = WatchConnectivityService.shared.applicationContext
        
        if context.favoriteShortcuts.count >= 10 {
            throw PerformError.limitReached
        }
        
        let newShortcut = WCAppContext.FavoriteShortcut(
            shortcutName: shortcutName,
            symbol: symbol ?? "suit.diamond"
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
