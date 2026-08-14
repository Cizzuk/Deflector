//
//  WidgetExtension.swift
//  WidgetExtension
//
//  Created by Cizzuk on 2026/08/14.
//

import AppIntents
import SwiftUI
import WidgetKit

struct DeflectorActivityWidget: Widget {
    let kind: String = "net.cizzuk.deflector.WidgetExtension.DeflectorActivityWidget"
    
    struct ShortcutButton: View {
        var button: DeflectorActivityButton
        
        var body: some View {
            Button(intent: SendDeflectionNotificationIntent(name: button.shortcutName)) {
                Label(button.shortcutName, systemImage: button.iconName)
            }
            .tint(ColorHelper.uInt32ToColor(button.color))
        }
    }
    
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
