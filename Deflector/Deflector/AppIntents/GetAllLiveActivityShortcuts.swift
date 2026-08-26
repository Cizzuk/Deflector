//
//  GetAllLiveActivityShortcuts.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/26.
//

import AppIntents

struct GetAllLiveActivityShortcuts: LiveActivityIntent {
    static let title: LocalizedStringResource = "Get All Live Activity Shortcuts"
    static let isDiscoverable = true
    static var supportedModes: IntentModes = .background
    
    @Parameter(title: "Get from Dynamic Island", default: false)
    var dynamicIsland: Bool
    
    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<[String]> {
        let buttons = dynamicIsland ? UserSettings.shared.liveActivityIslandButtons : UserSettings.shared.liveActivityButtons
        var shortcuts: [String] = []
        
        buttons.forEach { button in
            shortcuts.append(button.shortcutName)
        }
        
        return .result(value: shortcuts)
    }
}
