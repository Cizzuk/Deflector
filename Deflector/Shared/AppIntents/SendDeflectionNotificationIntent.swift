//
//  SendDeflectionNotificationIntent.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/12.
//

import AppIntents

struct SendDeflectionNotificationIntent: AppIntent {
    static let title: LocalizedStringResource = "Send Deflection Notification"
    static let isDiscoverable = false
    static var supportedModes: IntentModes = .background
    
    @Parameter(title: "Shortcut Name")
    var name: String
    
    init() {}
    init(name: String) {
        self.name = name
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        if name.isEmpty {
            await UserNotificationSupport.sendDeflectionErrorNotification(reason: "Shortcut name is unset")
        } else {
            await UserNotificationSupport.sendDeflectionNotification(name: name)
        }
        
        return .result()
    }
}
