//
//  ToggleActivityControl.swift
//  Deflector Widget Extension
//
//  Created by Cizzuk on 2026/02/05.
//

import SwiftUI
import WidgetKit

struct ToggleActivityControl: ControlWidget {
    static let kind = "net.cizzuk.deflector.WidgetExtension.ToggleActivityControl"
    static let title: LocalizedStringResource = "Toggle Activity"
    
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: ToggleActivityControl.kind) {
            ControlWidgetButton(action: ControlDeflectorActivityIntent(control: .toggle)) {
                Label(ToggleActivityControl.title, systemImage: deflectorSymbol)
            }
        }
        .displayName(ToggleActivityControl.title)
    }
}
