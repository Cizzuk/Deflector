//
//  WidgetExtensionBundle.swift
//  Deflector Widget Extension
//
//  Created by Cizzuk on 2026/08/14.
//

import SwiftUI
import WidgetKit

@main
struct WidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        DeflectorActivityWidget()
        ToggleActivityControl()
    }
}
