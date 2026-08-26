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
        @Environment(\.activityFamily) var activityFamily
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
                                .font(activityFamily == .small ? .title2 : .title)
                                .foregroundStyle(color)
                                .frame(width: 35, height: 35)
                            if showLabel && activityFamily != .small {
                                Text(button.shortcutName)
                                    .lineLimit(1)
                                    .font(.caption)
                                    .foregroundStyle(color.opacity(0.8))
                                    .accessibilityHidden(true)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .tint(ColorHelper.uInt32ToColor(button.color))
                }
            }
            .padding(.horizontal, activityFamily == .small ? 0 : 20)
        }
    }
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DeflectorActivityAttributes.self) { context in
            let buttons = context.state.buttons
            let background = context.state.blackBackground ? Color.black : Color.clear
            let showLabel = context.state.showShortcutNames
            ShortcutButtons(buttons: buttons, showLabel: showLabel)
                .padding(20)
                .activityBackgroundTint(background)
            
        } dynamicIsland: { context in
            let buttons = context.state.islandButtons ?? context.state.buttons
            let showLabel = context.state.showShortcutNames
            return DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    ShortcutButtons(buttons: buttons, showLabel: showLabel)
                        .padding(.bottom, showLabel ? 10 : 18)
                }
            } compactLeading: {
                EmptyView().frame(width: 0, height: 0)
            } compactTrailing: {
                EmptyView().frame(width: 0, height: 0)
            } minimal: {
                Label("Deflector", systemImage: "suit.diamond")
                    .labelStyle(.iconOnly)
                    .foregroundStyle(.dropblue)
                    .padding(.horizontal, 2)
            }
        }
        .supplementalActivityFamilies([.small, .medium])
    }
}
