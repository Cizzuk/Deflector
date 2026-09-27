//
//  WCAppContext.swift
//  Deflector
//
//  Created by Cizzuk on 2026/09/27.
//

import Foundation

struct WCAppContext: Codable {
    var favoriteShortcuts: [FavoriteShortcut] = []
    
    struct FavoriteShortcut: Codable, Identifiable {
        var shortcutName: String
        var symbol: String = "suit.diamond"
        
        var id: String { return shortcutName }
    }
    
    func toDictionary() -> [String: Any] {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return [:]
        }
        return dictionary
    }
    
    static func fromDictionary(_ dictionary: [String: Any]) -> WCAppContext? {
        let decoder = JSONDecoder()
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []),
              let context = try? decoder.decode(WCAppContext.self, from: data) else {
            return nil
        }
        return context
    }
}
