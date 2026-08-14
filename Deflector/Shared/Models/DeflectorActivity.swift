//
//  DeflectorActivity.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/14.
//

import ActivityKit
import Foundation
import SwiftUI

nonisolated struct DeflectorActivityButton: Codable, Equatable, Hashable {
    var shortcutName: String
    var iconName: String = "circle.fill"
    var color: UInt32 = 0x0000FFFF
}

nonisolated struct DeflectorActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var buttons: [DeflectorActivityButton]
    }
}
