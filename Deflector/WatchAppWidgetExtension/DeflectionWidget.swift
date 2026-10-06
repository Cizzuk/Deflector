//
//  DeflectionWidget.swift
//  Deflector Watch Widget Extension
//
//  Created by Cizzuk on 2026/10/04.
//

import AppIntents
import SwiftUI
import WidgetKit

struct DeflectionEntry: TimelineEntry {
    let date: Date = .now
    let shortcutName: String
    let symbol: String
}

struct DeflectionProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> DeflectionEntry {
        .init(shortcutName: "Shortcut", symbol: defaultShortcutSymbol)
    }
    
    func snapshot(
        for configuration: DeflectionWidgetConfigurationAppIntent,
        in context: Context
    ) async -> DeflectionEntry {
        .init(
            shortcutName: configuration.shortcutName,
            symbol: getSymbol(for: configuration.shortcutName) ?? defaultShortcutSymbol
        )
    }
    
    func timeline(
        for configuration: DeflectionWidgetConfigurationAppIntent,
        in context: Context
    ) async -> Timeline<DeflectionEntry> {
        let entry = DeflectionEntry(
            shortcutName: configuration.shortcutName,
            symbol: getSymbol(for: configuration.shortcutName) ?? defaultShortcutSymbol
        )
        
        return Timeline(entries: [entry], policy: .never)
    }
    
    func recommendations() -> [AppIntentRecommendation<DeflectionWidgetConfigurationAppIntent>] {
        []
    }
    
    private func getSymbol(for shortcutName: String) -> String? {
        let context = WCAppContext.loadLastContext()
        return context.favoriteShortcuts.first(where: { $0.shortcutName == shortcutName })?.symbol
    }
}

struct DeflectionWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: DeflectionProvider.Entry
    
    var widgetURL: URL? {
        guard let url = URL(string: "net.cizzuk.deflector://widget/deflection") else { return nil }
        return url.appending(queryItems: [.init(name: "shortcutName", value: entry.shortcutName)])
    }
    
    var body: some View {
        Group {
            switch family {
            case .accessoryCircular:
                ZStack {
                    AccessoryWidgetBackground()
                    Image(systemName: entry.symbol)
                        .resizable()
                        .scaledToFit()
                        .padding(10)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .accessibilityLabel(entry.shortcutName)
                }
                .widgetLabel(entry.shortcutName)
            case .accessoryCorner:
                Image(systemName: entry.symbol)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .widgetLabel(entry.shortcutName)
            case .accessoryInline:
                Label(entry.shortcutName, systemImage: entry.symbol)
                    .labelStyle(.titleAndIcon)
            case .accessoryRectangular:
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: entry.symbol)
                        .imageScale(.large)
                        .frame(height: .infinity, alignment: .center)
                        .accessibilityHidden(true)
                    Text(entry.shortcutName)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                .font(.headline)
                .accessibilityElement(children: .combine)
            @unknown default:
                Label(entry.shortcutName, systemImage: entry.symbol)
            }
        }
        .widgetAccentable()
        .widgetURL(widgetURL)
    }
}

struct DeflectionWidget: Widget {
    let kind: String = "net.cizzuk.deflector.watchkitapp.WidgetExtension.DeflectionWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: DeflectionWidgetConfigurationAppIntent.self,
            provider: DeflectionProvider()
        ) { entry in
            DeflectionWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Run Shortcut")
        .description("Run a shortcut on your iPhone.")
        .supportedFamilies([
            .accessoryCircular,
            .accessoryCorner,
            .accessoryInline,
            .accessoryRectangular
        ])
    }
}

struct DeflectionWidgetConfigurationAppIntent: WidgetConfigurationIntent {
    static let title: LocalizedStringResource = "Deflection Widget Configuration"
    
    @Parameter(
        title: "Shortcut Name",
        default: "Shortcut",
        optionsProvider: FavoriteShortcutOptionsProvider()
    )
    var shortcutName: String
}

struct FavoriteShortcutOptionsProvider: DynamicOptionsProvider {
    func results() async throws -> [String] {
        WCAppContext.loadLastContext().favoriteShortcuts.map(\.shortcutName)
    }
}
