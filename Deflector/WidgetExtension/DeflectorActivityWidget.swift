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
                    Button(intent: SendDeflectionNotificationIntent(shortcutName: button.shortcutName)) {
                        VStack(spacing: 2) {
                            let symbolImage = SymbolHelper.getSymbolImage(button.symbol)
                            let size: CGFloat = activityFamily == .small ? 26 : 38
                            if symbolImage.type != .none {
                                Label {
                                    Text(button.shortcutName)
                                } icon: {
                                    if symbolImage.type.isPicture {
                                        symbolImage.image?
                                            .resizable()
                                            .scaledToFit()
                                    } else {
                                        symbolImage.image?
                                            .font(.system(size: size*0.8, weight: .regular))
                                            .foregroundStyle(color)
                                    }
                                }
                                .frame(width: size, height: size)
                                .labelStyle(.iconOnly)
                                
                                if showLabel && activityFamily != .small {
                                    Text(button.shortcutName)
                                        .lineLimit(1)
                                        .font(.caption)
                                        .foregroundStyle(color.opacity(0.75))
                                        .accessibilityHidden(true)
                                }
                            } else {
                                Text(button.shortcutName)
                                    .lineLimit(2)
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundStyle(color)
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
    
    struct ActivityView: View {
        @Environment(\.activityFamily) var activityFamily
        var context: ActivityViewContext<DeflectorActivityAttributes>
        var dynamicIsland: DynamicIslandMode? = nil
        
        var body: some View {
            let isSmall = activityFamily == .small
            let showLabel = context.attributes.showShortcutNames
            
            if let dynamicIsland {
                let islandIcons = context.attributes.islandIcons ?? .deviceDefault
                let buttons = {
                    if let islandButtons = context.state.islandButtons {
                        return islandButtons
                    } else {
                        return context.state.buttons
                    }
                }()
                
                switch dynamicIsland {
                case .expanded:
                    ShortcutButtons(buttons: buttons, showLabel: showLabel)
                        .padding(.bottom, showLabel ? 15 : 18)
                case .compactLeading:
                    if islandIcons.compactLeading {
                        Image(systemName: "suit.diamond")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                            .fontWeight(.regular)
                            .foregroundStyle(.dropblue)
                            .padding(.horizontal, 2)
                    } else {
                        EmptyView().frame(width: 0, height: 0)
                    }
                case .compactTrailing:
                    if islandIcons.compactTrailing {
                        Image(systemName: islandIcons.compactLeading ? "square.2.layers.3d" : "suit.diamond")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                            .fontWeight(.regular)
                            .foregroundStyle(.dropblue)
                            .padding(.horizontal, 2)
                    } else {
                        EmptyView().frame(width: 0, height: 0)
                    }
                case .minimal:
                    if islandIcons.minimal {
                        Image(systemName: "suit.diamond")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                            .fontWeight(.regular)
                            .foregroundStyle(.dropblue)
                            .padding(.horizontal, 2)
                    } else {
                        EmptyView().frame(width: 0, height: 0)
                    }
                default:
                    EmptyView().frame(width: 0, height: 0)
                }
                
            } else {
                let blackBackground = context.attributes.blackBackground
                let buttons = context.state.buttons
                
                ShortcutButtons(buttons: buttons, showLabel: showLabel)
                    .padding(20)
                    .activityBackgroundTint((blackBackground || isSmall) ? .black : .clear)
            }
        }
    }
    
    var body: some WidgetConfiguration {
        let widgetURL = URL(string: "net.cizzuk.deflector://activity_action") ?? nil
        
        return ActivityConfiguration(for: DeflectorActivityAttributes.self) { context in
            ActivityView(context: context, dynamicIsland: nil)
                .widgetURL(widgetURL)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    ActivityView(context: context, dynamicIsland: .expanded)
                }
            } compactLeading: {
                ActivityView(context: context, dynamicIsland: .compactLeading)
            } compactTrailing: {
                ActivityView(context: context, dynamicIsland: .compactTrailing)
            } minimal: {
                ActivityView(context: context, dynamicIsland: .minimal)
            }
            .dynamicContentMargins(settings: context.attributes.islandIcons)
            .widgetURL(widgetURL)
        }
        .supplementalActivityFamilies([.small, .medium])
    }
}

extension DynamicIsland {
    func dynamicContentMargins(settings: DeflectorActivityIslandIcons?) -> DynamicIsland {
        let islandIcons = settings ?? .deviceDefault
        
        var modifiedIsland = self
        if !islandIcons.compactLeading {
            modifiedIsland = modifiedIsland.contentMargins(.all, 0, for: .compactLeading)
        }
        if !islandIcons.compactTrailing {
            modifiedIsland = modifiedIsland.contentMargins(.all, 0, for: .compactTrailing)
        }
        if !islandIcons.minimal {
            modifiedIsland = modifiedIsland.contentMargins(.all, 0, for: .minimal)
        }
        return modifiedIsland
    }
}
