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
    
    struct ShortcutButtons: View {
        var buttons: [DeflectorActivityButton]
        var showLabel: Bool = true
        
        var body: some View {
            let columns = Array(repeating: GridItem(.flexible()), count: buttons.count)
            LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                ForEach(buttons) { button in
                    let color = ColorHelper.uInt32ToColor(button.color)
                    Button(intent: SendDeflectionNotificationIntent(name: button.shortcutName)) {
                        VStack(spacing: 2) {
                            Label(button.shortcutName, systemImage: button.iconName)
                                .labelStyle(.iconOnly)
                                .font(.title)
                                .foregroundStyle(color)
                                .frame(width: 35, height: 35)
                            Text(button.shortcutName)
                                .lineLimit(1)
                                .font(.caption)
                                .foregroundStyle(color.opacity(0.8))
                                .accessibilityHidden(true)
                        }
                    }
                    .buttonStyle(.plain)
                    .tint(ColorHelper.uInt32ToColor(button.color))
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DeflectorActivityAttributes.self) { context in
            let buttons = context.state.buttons
            ShortcutButtons(buttons: buttons)
            .padding(20)
            .activityBackgroundTint(.clear)
        } dynamicIsland: { context in
            let buttons = context.state.islandButtons ?? context.state.buttons
            return DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    ShortcutButtons(buttons: buttons)
                    .padding(.bottom, 10)
                }
            } compactLeading: {
                Label("Deflector", systemImage: "suit.diamond.fill")
                    .labelStyle(.iconOnly)
                    .foregroundStyle(.dropblue)
                    .padding(.leading, 2)
            } compactTrailing: {
                EmptyView()
            } minimal: {
                Label("Deflector", systemImage: "suit.diamond.fill")
                    .labelStyle(.iconOnly)
                    .foregroundStyle(.dropblue)
            }
        }
    }
}
