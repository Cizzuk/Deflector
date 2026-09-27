//
//  WCAppContext.swift
//  Deflector
//
//  Created by Cizzuk on 2026/09/27.
//

struct WCAppContext: Codable {
    var favoriteShortcuts: [FavoriteShortcut]
    
    struct FavoriteShortcut: Codable, Identifiable {
        var shortcutName: String
        var symbol: String = "suit.diamond"
        
        var id: String { return shortcutName }
    }
}
