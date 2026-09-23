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
        static let isFirstSetupCompleted = "isFirstSetupCompleted"
        
        static let sideButtonShortcutName = "sideButtonShortcutName"
        
        static let liveActivityButtons = "liveActivityButtons"
        static let liveActivityIslandButtons = "liveActivityIslandButtons"
        static let liveActivityUseDifferentOnIsland = "liveActivityUseDifferentOnIsland"
        
        static let liveActivityUseBlackBackground = "liveActivityUseBlackBackground"
        static let liveActivityShowShortcutNames = "liveActivityShowShortcutNames"
        static let liveActivityIslandIcons = "liveActivityIslandIcons"
    }
    
    @Published var isFirstSetupCompleted: Bool = {
        return UserDefaults.standard.bool(forKey: Keys.isFirstSetupCompleted)
    }() {
        didSet {
            UserDefaults.standard.set(isFirstSetupCompleted, forKey: Keys.isFirstSetupCompleted)
        }
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
    
    @Published var liveActivityButtons: [DeflectorActivityButton] = {
        guard let data = UserDefaults.standard.data(forKey: Keys.liveActivityButtons) else {
            return [DeflectorActivityButton(shortcutName: "")]
        }
        
        guard let buttons = try? JSONDecoder().decode([DeflectorActivityButton].self, from: data) else {
            return []
        }
        
        return buttons
    }() {
        didSet {
            if let data = try? JSONEncoder().encode(liveActivityButtons) {
                UserDefaults.standard.set(data, forKey: Keys.liveActivityButtons)
                DeflectorActivitySupport.update()
            }
        }
    }
    
    @Published var liveActivityIslandButtons: [DeflectorActivityButton] = {
        guard let data = UserDefaults.standard.data(forKey: Keys.liveActivityIslandButtons) else {
            return [DeflectorActivityButton(shortcutName: "")]
        }
        
        guard let buttons = try? JSONDecoder().decode([DeflectorActivityButton].self, from: data) else {
            return []
        }
        
        return buttons
    }() {
        didSet {
            if let data = try? JSONEncoder().encode(liveActivityIslandButtons) {
                UserDefaults.standard.set(data, forKey: Keys.liveActivityIslandButtons)
                DeflectorActivitySupport.update()
            }
        }
    }
    
    @Published var liveActivityUseDifferentOnIsland: Bool = {
        return UserDefaults.standard.bool(forKey: Keys.liveActivityUseDifferentOnIsland)
    }() {
        didSet {
            UserDefaults.standard.set(liveActivityUseDifferentOnIsland, forKey: Keys.liveActivityUseDifferentOnIsland)
            DeflectorActivitySupport.update()
        }
    }
    
    @Published var liveActivityUseBlackBackground: Bool = {
        return UserDefaults.standard.bool(forKey: Keys.liveActivityUseBlackBackground)
    }() {
        didSet {
            UserDefaults.standard.set(liveActivityUseBlackBackground, forKey: Keys.liveActivityUseBlackBackground)
            try? DeflectorActivitySupport.refresh()
        }
    }
    
    @Published var liveActivityShowShortcutNames: Bool = {
        return UserDefaults.standard.bool(forKey: Keys.liveActivityShowShortcutNames)
    }() {
        didSet {
            UserDefaults.standard.set(liveActivityShowShortcutNames, forKey: Keys.liveActivityShowShortcutNames)
            try? DeflectorActivitySupport.refresh()
        }
    }
    
    @Published var liveActivityIslandIcons: DeflectorActivityIslandIcons? = {
        guard let data = UserDefaults.standard.data(forKey: Keys.liveActivityIslandIcons),
              let icons = try? JSONDecoder().decode(DeflectorActivityIslandIcons.self, from: data)
        else {
            return nil
        }
        
        return icons
    }() {
        didSet {
            if let icons = liveActivityIslandIcons,
                let data = try? JSONEncoder().encode(icons) {
                UserDefaults.standard.set(data, forKey: Keys.liveActivityIslandIcons)
            } else {
                UserDefaults.standard.removeObject(forKey: Keys.liveActivityIslandIcons)
            }
            
            try? DeflectorActivitySupport.refresh()
        }
    }
}
