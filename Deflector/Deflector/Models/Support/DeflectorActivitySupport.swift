//
//  DeflectorActivitySupport.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/14.
//

import ActivityKit
import Foundation

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
        let blackBackground = UserSettings.shared.liveActivityUseBlackBackground
        
        let state = DeflectorActivityAttributes.ContentState(
            buttons: buttons,
            islandButtons: useDifferentOnIsland ? islandButtons : nil,
            blackBackground: UserSettings.shared.liveActivityUseBlackBackground
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
    }
}
