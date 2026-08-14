//
//  WidgetExtension.swift
//  WidgetExtension
//
//  Created by Cizzuk on 2026/08/14.
//

import WidgetKit
import SwiftUI

struct DeflectorActivityWidget: Widget {
    let kind: String = "net.cizzuk.deflector.WidgetExtension.DeflectorActivityWidget"
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DeflectorActivityAttributes.self) { context in
            EmptyView()
                .containerBackground(.clear, for: .widget)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    EmptyView()
                }
            } compactLeading: {
                EmptyView()
            } compactTrailing: {
                EmptyView()
            } minimal: {
                EmptyView()
            }
        }
    }
}
