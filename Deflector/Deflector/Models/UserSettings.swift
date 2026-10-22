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
    
    // Manage Library/UserSettings/ data files
    private enum Store {
        private static let directoryURL: URL = {
            let libraryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let directoryURL = libraryURL.appending(path: "UserSettings", directoryHint: .isDirectory)
            try? FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            return directoryURL
        }()
        
        private static func fileURL(for key: String) -> URL {
            directoryURL.appending(path: key, directoryHint: .notDirectory)
        }
        
        static func contents(for key: String) -> Data? {
            try? Data(contentsOf: fileURL(for: key))
        }
        
        static func load<T: Codable>(for key: String) -> T? {
            if let data = contents(for: key) {
                return try? JSONDecoder().decode(T.self, from: data)
            }
            
            // Migrate from UserDefaults to FileManager
            if let userDefaultsObject = UserDefaults.standard.object(forKey: key) {
                let value: T?
                if let data = userDefaultsObject as? Data,
                   let decoded = try? JSONDecoder().decode(T.self, from: data) {
                    value = decoded
                } else {
                    value = userDefaultsObject as? T
                }
                
                if let value, save(value, for: key) {
                    UserDefaults.standard.removeObject(forKey: key)
                }
                return value
            }
            
            return nil
        }
        
        @discardableResult
        static func save<T: Codable>(_ value: T, for key: String) -> Bool {
            do {
                let data = try JSONEncoder().encode(value)
                try data.write(to: fileURL(for: key), options: .atomic)
                return true
            } catch {
                return false
            }
        }
        
        static func remove(for key: String) {
            try? FileManager.default.removeItem(at: fileURL(for: key))
        }
    }
    
    // MARK: - User Settings
    
    @Published var isFirstSetupCompleted: Bool = Store.load(for: Keys.isFirstSetupCompleted) ?? false {
        didSet {
            Store.save(isFirstSetupCompleted, for: Keys.isFirstSetupCompleted)
        }
    }
    
    @Published var sideButtonShortcutName: String = Store.load(for: Keys.sideButtonShortcutName) ?? "" {
        didSet {
            Store.save(sideButtonShortcutName, for: Keys.sideButtonShortcutName)
        }
    }
    
    @Published var liveActivityButtons: [DeflectorActivityButton] = Store.load(for: Keys.liveActivityButtons) ?? [DeflectorActivityButton(shortcutName: "")] {
        didSet {
            Store.save(liveActivityButtons, for: Keys.liveActivityButtons)
            Task { await DeflectorActivitySupport.update() }
        }
    }
    
    @Published var liveActivityIslandButtons: [DeflectorActivityButton] = Store.load(for: Keys.liveActivityIslandButtons) ?? [DeflectorActivityButton(shortcutName: "")] {
        didSet {
            Store.save(liveActivityIslandButtons, for: Keys.liveActivityIslandButtons)
            Task { await DeflectorActivitySupport.update() }
        }
    }
    
    @Published var liveActivityUseDifferentOnIsland: Bool = Store.load(for: Keys.liveActivityUseDifferentOnIsland) ?? false {
        didSet {
            Store.save(liveActivityUseDifferentOnIsland, for: Keys.liveActivityUseDifferentOnIsland)
            Task { await DeflectorActivitySupport.update() }
        }
    }
    
    @Published var liveActivityUseBlackBackground: Bool = Store.load(for: Keys.liveActivityUseBlackBackground) ?? false {
        didSet {
            Store.save(liveActivityUseBlackBackground, for: Keys.liveActivityUseBlackBackground)
            Task { try? await DeflectorActivitySupport.refresh() }
        }
    }
    
    @Published var liveActivityShowShortcutNames: Bool = Store.load(for: Keys.liveActivityShowShortcutNames) ?? false {
        didSet {
            Store.save(liveActivityShowShortcutNames, for: Keys.liveActivityShowShortcutNames)
            Task { try? await DeflectorActivitySupport.refresh() }
        }
    }
    
    @Published var liveActivityIslandIcons: DeflectorActivityIslandIcons? = Store.load(for: Keys.liveActivityIslandIcons) {
        didSet {
            if let icons = liveActivityIslandIcons {
                Store.save(icons, for: Keys.liveActivityIslandIcons)
            } else {
                Store.remove(for: Keys.liveActivityIslandIcons)
            }
            Task { try? await DeflectorActivitySupport.refresh() }
        }
    }
}
