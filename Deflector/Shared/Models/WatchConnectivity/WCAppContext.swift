//
//  WCAppContext.swift
//  Deflector
//
//  Created by Cizzuk on 2026/09/27.
//

import Foundation

struct WCAppContext: Codable, Equatable {
    var favoriteShortcuts: [FavoriteShortcut]
    var allowShowAllShortcuts: Bool
    
    struct FavoriteShortcut: Codable, Equatable, Identifiable {
        var shortcutName: String
        var symbol: String = "suit.diamond"
        
        var id: String { return shortcutName }
    }
    
    init(
        favoriteShortcuts: [FavoriteShortcut] = [],
        allowShowAllShortcuts: Bool = true
    ) {
        self.favoriteShortcuts = favoriteShortcuts
        self.allowShowAllShortcuts = allowShowAllShortcuts
    }
    
    init(_ dictionary: [String: Any]) throws {
        let decoder = JSONDecoder()
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let context = try decoder.decode(WCAppContext.self, from: data)
        self = context
    }
    
    func toDictionary() -> [String: Any] {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return [:]
        }
        return dictionary
    }
}
