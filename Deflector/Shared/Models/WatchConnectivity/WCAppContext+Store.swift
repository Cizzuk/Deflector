//
//  WCAppContext+Store.swift
//  Deflector
//
//  Created by Cizzuk on 2026/09/27.
//

import Foundation

extension WCAppContext {
    static let groupUserDefaults = UserDefaults(suiteName: appGroupID)
    static let key = "watchkitapp.lastApplicationContext"
    
    static func loadLastContext() -> WCAppContext {
        guard let data = groupUserDefaults?.data(forKey: key),
              let context = try? JSONDecoder().decode(WCAppContext.self, from: data) else {
            return WCAppContext()
        }
        
        return context
    }

    func saveLastContext() throws {
        let data = try JSONEncoder().encode(self)
        Self.groupUserDefaults?.set(data, forKey: Self.key)
    }
}
