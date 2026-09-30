//
//  DeflectorActivitySupport.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/14.
//

import ActivityKit
import UserNotifications

class DeflectorActivitySupport {
    static func isActive() -> Bool {
        return !Activity<DeflectorActivityAttributes>.activities.isEmpty
    }
    
    static func isEnabled() -> Bool {
        return ActivityAuthorizationInfo().areActivitiesEnabled
    }
    
    private static func makeAttributes() -> DeflectorActivityAttributes {
        return DeflectorActivityAttributes(
            blackBackground: UserSettings.shared.liveActivityUseBlackBackground,
            showShortcutNames: UserSettings.shared.liveActivityShowShortcutNames,
            islandIcons: UserSettings.shared.liveActivityIslandIcons
        )
    }
    
    private static func makeContentState() -> DeflectorActivityAttributes.ContentState {
        let buttons = UserSettings.shared.liveActivityButtons
        let islandButtons = UserSettings.shared.liveActivityIslandButtons
        let useDifferentOnIsland = UserSettings.shared.liveActivityUseDifferentOnIsland
        
        let state = DeflectorActivityAttributes.ContentState(
            buttons: buttons,
            islandButtons: useDifferentOnIsland ? islandButtons : nil
        )
        
        return state
    }
    
    static func start(endDate: Date? = nil) async throws {
        await endAll()
        
        let content = ActivityContent(
            state: makeContentState(),
            staleDate: endDate
        )
        
        let _ = try Activity.request(
            attributes: makeAttributes(),
            content: content,
            pushType: nil
        )
        
        // Prepare a system call for automatic restart.
        await SystemCallSupport.cancelSystemCalls(.refreshDeflectorActivity)
        let triggerRefresh = UNTimeIntervalNotificationTrigger(timeInterval: 7.75 * 60 * 60, repeats: false)
        await SystemCallSupport.addSystemCall(.refreshDeflectorActivity, trigger: triggerRefresh)
    }
    
    static func update() async {
        let activities = Activity<DeflectorActivityAttributes>.activities
        
        let content = ActivityContent(
            state: makeContentState(),
            staleDate: nil
        )
        
        for activity in activities {
            await activity.update(content)
        }
    }
    
    static func endAll() async {
        let activities = Activity<DeflectorActivityAttributes>.activities
        
        Task.detached(priority: .userInitiated) {
            for activity in activities {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
        }
        
        // Remove the system call for automatic restart.
        await SystemCallSupport.cancelSystemCalls(.refreshDeflectorActivity)
    }
    
    // If activity is active, restart it to extend the time
    static func refresh() async throws {
        if isActive() {
            try await start()
        }
    }
}
