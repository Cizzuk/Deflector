//
//  OpenDeflectorWidget.swift
//  Deflector Watch Widget Extension
//
//  Created by Cizzuk on 2026/10/04.
//

import WidgetKit
import SwiftUI

struct OpenDeflectorProvider: TimelineProvider {
    func placeholder(in context: Context) -> OpenDeflectorEntry {
        OpenDeflectorEntry()
    }
    
    func getSnapshot(in context: Context, completion: @escaping (OpenDeflectorEntry) -> Void) {
        completion(OpenDeflectorEntry())
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<OpenDeflectorEntry>) -> Void) {
        completion(Timeline(entries: [OpenDeflectorEntry()], policy: .never))
    }
}

struct OpenDeflectorEntry: TimelineEntry {
    let date: Date = .now
}

struct OpenDeflectorWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: OpenDeflectorProvider.Entry
    
    var body: some View {
        Group {
            switch family {
            case .accessoryCircular:
                ZStack {
                    AccessoryWidgetBackground()
                    Image(systemName: deflectorSymbol)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.dropblue)
                        .padding(10)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .accessibilityLabel("Open Deflector")
                }
            case .accessoryCorner:
                Image(systemName: deflectorSymbol)
                    .resizable()
                    .scaledToFit()
                    .padding(2)
                    .foregroundStyle(.dropblue)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .accessibilityLabel("Open Deflector")
            default:
                Label("Open Deflector", systemImage: deflectorSymbol)
            }
        }
        .widgetAccentable()
        .widgetURL(URL(string: "net.cizzuk.deflector://widget/open") ?? nil)
    }
}

struct OpenDeflectorWidget: Widget {
    let kind: String = "net.cizzuk.deflector.watchkitapp.WidgetExtension.OpenDeflectorWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: OpenDeflectorProvider()) { entry in
            OpenDeflectorWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Open Deflector")
        .description("Open Deflector and show your favorite shortcuts.")
        .supportedFamilies([
            .accessoryCircular,
            .accessoryCorner
        ])
    }
}
