//
//  DeflectionWidget.swift
//  Deflector Watch Widget Extension
//
//  Created by Cizzuk on 2026/10/04.
//

import WidgetKit
import SwiftUI

struct DeflectionProvider: TimelineProvider {
    func placeholder(in context: Context) -> DeflectionEntry {
        DeflectionEntry(shortcutName: "Shortcut")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (DeflectionEntry) -> Void) {
        completion(DeflectionEntry(shortcutName: "Shortcut"))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<DeflectionEntry>) -> Void) {
        completion(Timeline(entries: [DeflectionEntry(shortcutName: "Shortcut")], policy: .never))
    }
}

struct DeflectionEntry: TimelineEntry {
    let date: Date = .now
    let shortcutName: String
    let symbol: String = defaultShortcutSymbol
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
        StaticConfiguration(kind: kind, provider: DeflectionProvider()) { entry in
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
