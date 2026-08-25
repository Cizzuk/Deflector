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
    
    private static func makeContentState() -> DeflectorActivityAttributes.ContentState {
        let buttons = UserSettings.shared.liveActivityButtons
        let islandButtons = UserSettings.shared.liveActivityIslandButtons
        let useDifferentOnIsland = UserSettings.shared.liveActivityUseDifferentOnIsland
        
        let state = DeflectorActivityAttributes.ContentState(
            buttons: buttons,
            islandButtons: useDifferentOnIsland ? islandButtons : nil,
            blackBackground: UserSettings.shared.liveActivityUseBlackBackground,
            showShortcutNames: UserSettings.shared.liveActivityShowShortcutNames
        )
        
        return state
    }
    
    static func start(endDate: Date? = nil) throws {
        endAll()
        
        let content = ActivityContent(
            state: makeContentState(),
            staleDate: endDate
        )
        
        let _ = try Activity.request(
            attributes: DeflectorActivityAttributes(),
            content: content,
            pushType: nil
        )
        
        // Prepared a system call for automatic restart
        if UserSettings.shared.liveActivityAutoRestart {
            Task {
                await SystemCallSupport.cancelSystemCalls(.refreshDeflectorActivity)
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 7.5 * 60 * 60, repeats: false)
                await SystemCallSupport.addSystemCall(.refreshDeflectorActivity, trigger: trigger)
            }
        }
    }
    
    static func update() {
        let activities = Activity<DeflectorActivityAttributes>.activities
        
        let content = ActivityContent(
            state: makeContentState(),
            staleDate: nil
        )
        
        Task {
            for activity in activities {
                await activity.update(content)
            }
        }
    }
    
    static func endAll() {
        let activities = Activity<DeflectorActivityAttributes>.activities
        
        let semaphore = DispatchSemaphore(value: 0)
        Task.detached(priority: .userInitiated) {
            for activity in activities {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
            semaphore.signal()
        }
        semaphore.wait()
        
        // Remove the system call for automatic restart
        Task {
            await SystemCallSupport.cancelSystemCalls(.refreshDeflectorActivity)
        }
    }
    
    // If activity is active, restart it to extend the time
    static func refresh() throws {
        if UserSettings.shared.liveActivityAutoRestart && isActive() {
            try start()
        }
    }
}
