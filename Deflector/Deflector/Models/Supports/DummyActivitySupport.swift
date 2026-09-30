//
//  DummyActivitySupport.swift
//  Deflector
//
//  Created by Cizzuk on 2026/09/30.
//

import ActivityKit
import Foundation

class DummyActivitySupport {
    nonisolated struct DummyAttributes: ActivityAttributes {
        struct ContentState: Codable, Hashable { }
    }
    
    // LiveActivityIntent will freeze for 5 seconds if the activity is not started.
    // To avoid this, start a dummy activity and immediately end it.
    static func flash() {
        Task.detached(priority: .high) {
            let content = ActivityContent(
                state: DummyAttributes.ContentState(),
                staleDate: Date.now
            )
            
            _ = try? Activity.request(
                attributes: DummyAttributes(),
                content: content,
                pushType: nil
            )
            
            let activities = Activity<DummyAttributes>.activities
            for activity in activities {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
        }
    }
}
