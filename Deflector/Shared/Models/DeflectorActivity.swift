//
//  DeflectorActivity.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/14.
//

import ActivityKit
import Foundation
import SwiftUI

nonisolated struct DeflectorActivityButton: Codable, Equatable, Hashable, Identifiable {
    var id: UUID = UUID()
    var shortcutName: String
    var iconName: String = "suit.diamond"
    var color: UInt32 = 0x3366FFFF
}

nonisolated struct DeflectorActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var buttons: [DeflectorActivityButton]
        var islandButtons: [DeflectorActivityButton]?
    }
}
