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
        if let data = UserDefaults.standard.data(forKey: Keys.liveActivityButtons),
           let buttons = try? JSONDecoder().decode([DeflectorActivityButton].self, from: data) {
            return buttons
        }
        
        return []
    }() {
        didSet {
            if let data = try? JSONEncoder().encode(liveActivityButtons) {
                UserDefaults.standard.set(data, forKey: Keys.liveActivityButtons)
                DeflectorActivitySupport.update()
            }
        }
    }
    
    @Published var liveActivityIslandButtons: [DeflectorActivityButton] = {
        if let data = UserDefaults.standard.data(forKey: Keys.liveActivityIslandButtons),
           let buttons = try? JSONDecoder().decode([DeflectorActivityButton].self, from: data) {
            return buttons
        }
        
        return []
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
            DeflectorActivitySupport.update()
        }
    }
    
    @Published var liveActivityShowShortcutNames: Bool = {
        if UserDefaults.standard.object(forKey: Keys.liveActivityShowShortcutNames) == nil {
            return true
        }
        return UserDefaults.standard.bool(forKey: Keys.liveActivityShowShortcutNames)
    }() {
        didSet {
            UserDefaults.standard.set(liveActivityShowShortcutNames, forKey: Keys.liveActivityShowShortcutNames)
            DeflectorActivitySupport.update()
        }
    }
}
