//
//  UserSettings.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/11.
//

import Combine
import Foundation

extension Notification.Name {
    static let userSettingsLoadFailed = Notification.Name("userSettingsLoadFailed")
}

final class UserSettings: ObservableObject {
    static let shared = UserSettings()
    
    private enum Keys {
        static let hasLaunchedBefore = "hasLaunchedBefore"
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
        // Validate UserDefaults data
        Task {
            let hasLaunchedBefore = UserDefaults.standard.bool(forKey: Keys.hasLaunchedBefore)
            if hasLaunchedBefore {
                print("UserSettings loaded successfully")
            } else {
                let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                let flagFileURL = directory?.appendingPathComponent("hasLaunchedBefore")
                
                // Check if the flag file exists
                if let flagFileURL, FileManager.default.fileExists(atPath: flagFileURL.path) {
                    NotificationCenter.default.post(name: .userSettingsLoadFailed, object: nil)
                    await UserNotificationSupport.addNotificationToDisplay(subtitle: "User Settings Load Failed")
                    print("UserSettings failed to load.")
                    return
                } else {
                    // If the flag file does not exist, this is the first launch
                    print("First launch maybe detected.")
                    UserDefaults.standard.set(true, forKey: Keys.hasLaunchedBefore)
                    // Create the flag file
                    if let flagFileURL {
                        try? Data().write(to: flagFileURL)
                        print("Flag file created at: \(flagFileURL.path)")
                    }
                }
            }
        }
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
                Task { await DeflectorActivitySupport.update() }
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
                Task { await DeflectorActivitySupport.update() }
            }
        }
    }
    
    @Published var liveActivityUseDifferentOnIsland: Bool = {
        return UserDefaults.standard.bool(forKey: Keys.liveActivityUseDifferentOnIsland)
    }() {
        didSet {
            UserDefaults.standard.set(liveActivityUseDifferentOnIsland, forKey: Keys.liveActivityUseDifferentOnIsland)
            Task { await DeflectorActivitySupport.update() }
        }
    }
    
    @Published var liveActivityUseBlackBackground: Bool = {
        return UserDefaults.standard.bool(forKey: Keys.liveActivityUseBlackBackground)
    }() {
        didSet {
            UserDefaults.standard.set(liveActivityUseBlackBackground, forKey: Keys.liveActivityUseBlackBackground)
            Task { try? await DeflectorActivitySupport.refresh() }
        }
    }
    
    @Published var liveActivityShowShortcutNames: Bool = {
        return UserDefaults.standard.bool(forKey: Keys.liveActivityShowShortcutNames)
    }() {
        didSet {
            UserDefaults.standard.set(liveActivityShowShortcutNames, forKey: Keys.liveActivityShowShortcutNames)
            Task { try? await DeflectorActivitySupport.refresh() }
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
            
            Task { try? await DeflectorActivitySupport.refresh() }
        }
    }
}
