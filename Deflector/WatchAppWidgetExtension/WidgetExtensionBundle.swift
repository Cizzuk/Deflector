//
//  WidgetExtensionBundle.swift
//  Deflector Watch Widget Extension
//
//  Created by Cizzuk on 2026/10/04.
//

import SwiftUI
import WidgetKit

@main
struct WidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        DeflectionWidget()
        OpenDeflectorWidget()
    }
}
