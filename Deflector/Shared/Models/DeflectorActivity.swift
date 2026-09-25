//
//  DeflectorActivity.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/14.
//

import ActivityKit
import Foundation
import SwiftUI
import WidgetKit

nonisolated struct DeflectorActivityButton: Codable, Equatable, Hashable, Identifiable {
    var id: UUID = UUID()
    var shortcutName: String
    var symbol: String = "suit.diamond"
    var color: UInt32 = 0xFFFFFFFF
}

struct DeflectorActivityIslandIcons: Codable, Equatable, Hashable {
    var compactLeading: Bool
    var compactTrailing: Bool
    var minimal: Bool
    
    static let deviceDefault: DeflectorActivityIslandIcons = {
        let placementForModel: [DynamicIslandMode] = {
            switch DeviceInfo.dynamicIslandType {
            case .vertical:
                return [.compactLeading, .compactTrailing, .minimal]
            case .horizontal:
                return [.minimal]
            default:
                return [.compactLeading, .minimal]
            }
        }()
        
        return DeflectorActivityIslandIcons(
            compactLeading: placementForModel.contains(.compactLeading),
            compactTrailing: placementForModel.contains(.compactTrailing),
            minimal: placementForModel.contains(.minimal)
        )
    }()
}

nonisolated struct DeflectorActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var buttons: [DeflectorActivityButton]
        var islandButtons: [DeflectorActivityButton]?
    }
    
    var blackBackground: Bool
    var showShortcutNames: Bool
    var islandIcons: DeflectorActivityIslandIcons?
}
