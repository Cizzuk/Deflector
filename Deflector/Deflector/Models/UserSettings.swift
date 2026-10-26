//
//  UserSettings.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/11.
//

import Combine
import UIKit

final class UserSettings: ObservableObject {
    static let shared = UserSettings()
    
    private struct Keys {
        static let isFirstSetupCompleted = "isFirstSetupCompleted"
        static let sideButtonShortcutName = "sideButtonShortcutName"
        static let liveActivityButtons = "liveActivityButtons"
        static let liveActivityIslandButtons = "liveActivityIslandButtons"
        static let liveActivityUseDifferentOnIsland = "liveActivityUseDifferentOnIsland"
        static let liveActivityUseBlackBackground = "liveActivityUseBlackBackground"
        static let liveActivityShowShortcutNames = "liveActivityShowShortcutNames"
        static let liveActivityIslandIcons = "liveActivityIslandIcons"
    }
    
    private init() {
        loadSettings()
    }
    
    private var isSettingsLoaded = false
    func isSettingsAvailable() -> Bool {
        if isSettingsLoaded {
            return true
        }
        
        loadSettings()
        return isSettingsLoaded
    }
    
    private func loadSettings() {
        func setSettingsLoaded() {
            if !isSettingsLoaded {
                isSettingsLoaded = true
            }
        }
        
        // isFirstSetupCompleted
        if UserDefaults.standard.object(forKey: Keys.isFirstSetupCompleted) != nil {
            isFirstSetupCompleted = UserDefaults.standard.bool(forKey: Keys.isFirstSetupCompleted)
            setSettingsLoaded()
        }
        
        // sideButtonShortcutName
        if let value = UserDefaults.standard.string(forKey: Keys.sideButtonShortcutName) {
            sideButtonShortcutName = value
            setSettingsLoaded()
        }
        
        // liveActivityButtons
        if let data = UserDefaults.standard.data(forKey: Keys.liveActivityButtons),
           let buttons = try? JSONDecoder().decode([DeflectorActivityButton].self, from: data) {
            liveActivityButtons = buttons
            setSettingsLoaded()
        }
        
        // liveActivityIslandButtons
        if let data = UserDefaults.standard.data(forKey: Keys.liveActivityIslandButtons),
           let buttons = try? JSONDecoder().decode([DeflectorActivityButton].self, from: data) {
            liveActivityIslandButtons = buttons
            setSettingsLoaded()
        }
        
        // liveActivityUseDifferentOnIsland
        if UserDefaults.standard.object(forKey: Keys.liveActivityUseDifferentOnIsland) != nil {
            liveActivityUseDifferentOnIsland = UserDefaults.standard.bool(forKey: Keys.liveActivityUseDifferentOnIsland)
            setSettingsLoaded()
        }
        
        // liveActivityUseBlackBackground
        if UserDefaults.standard.object(forKey: Keys.liveActivityUseBlackBackground) != nil {
            liveActivityUseBlackBackground = UserDefaults.standard.bool(forKey: Keys.liveActivityUseBlackBackground)
            setSettingsLoaded()
        }
        
        // liveActivityShowShortcutNames
        if UserDefaults.standard.object(forKey: Keys.liveActivityShowShortcutNames) != nil {
            liveActivityShowShortcutNames = UserDefaults.standard.bool(forKey: Keys.liveActivityShowShortcutNames)
            setSettingsLoaded()
        }
        
        // liveActivityIslandIcons
        if let data = UserDefaults.standard.data(forKey: Keys.liveActivityIslandIcons),
           let icons = try? JSONDecoder().decode(DeflectorActivityIslandIcons.self, from: data) {
            liveActivityIslandIcons = icons
            setSettingsLoaded()
        }
    }
    
    @Published var isFirstSetupCompleted: Bool = false {
        didSet {
            UserDefaults.standard.set(isFirstSetupCompleted, forKey: Keys.isFirstSetupCompleted)
        }
    }
    
    @Published var sideButtonShortcutName: String = "" {
        didSet {
            UserDefaults.standard.set(sideButtonShortcutName, forKey: Keys.sideButtonShortcutName)
        }
    }
    
    @Published var liveActivityButtons: [DeflectorActivityButton] = [DeflectorActivityButton(shortcutName: "")] {
        didSet {
            if let data = try? JSONEncoder().encode(liveActivityButtons) {
                UserDefaults.standard.set(data, forKey: Keys.liveActivityButtons)
                Task { await DeflectorActivitySupport.update() }
            }
        }
    }
    
    @Published var liveActivityIslandButtons: [DeflectorActivityButton] = [DeflectorActivityButton(shortcutName: "")] {
        didSet {
            if let data = try? JSONEncoder().encode(liveActivityIslandButtons) {
                UserDefaults.standard.set(data, forKey: Keys.liveActivityIslandButtons)
                Task { await DeflectorActivitySupport.update() }
            }
        }
    }
    
    @Published var liveActivityUseDifferentOnIsland: Bool = false {
        didSet {
            UserDefaults.standard.set(liveActivityUseDifferentOnIsland, forKey: Keys.liveActivityUseDifferentOnIsland)
            Task { await DeflectorActivitySupport.update() }
        }
    }
    
    @Published var liveActivityUseBlackBackground: Bool = false {
        didSet {
            UserDefaults.standard.set(liveActivityUseBlackBackground, forKey: Keys.liveActivityUseBlackBackground)
            Task { try? await DeflectorActivitySupport.refresh() }
        }
    }
    
    @Published var liveActivityShowShortcutNames: Bool = false {
        didSet {
            UserDefaults.standard.set(liveActivityShowShortcutNames, forKey: Keys.liveActivityShowShortcutNames)
            Task { try? await DeflectorActivitySupport.refresh() }
        }
    }
    
    @Published var liveActivityIslandIcons: DeflectorActivityIslandIcons? = nil {
        didSet {
            if let icons = liveActivityIslandIcons,
               let data = try? JSONEncoder().encode(icons) {
                UserDefaults.standard.set(data, forKey: Keys.liveActivityIslandIcons)
            } else {
                UserDefaults.standard.removeObject(forKey: Keys.liveActivityIslandIcons)
            }
            
            Task { try? await DeflectorActivitySupport.refresh() }
        }
    }
}
