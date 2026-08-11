//
//  UserSettings.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/11.
//

import Combine
import Foundation

final class UserSettings: ObservableObject {
    static let shared = UserSettings()
    private init() { }

    private enum Keys {
        static let sideButtonShortcutName = "sideButtonShortcutName"
    }
    
    @Published var sideButtonShortcutName: String = {
        if let value = UserDefaults.standard.string(forKey: Keys.sideButtonShortcutName) {
            return value
        }
        
        return ""
    }() {
        didSet {
            UserDefaults.standard.set(sideButtonShortcutName, forKey: Keys.sideButtonShortcutName)
        }
    }
}
