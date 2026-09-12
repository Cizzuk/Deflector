//
//  DynamicIslandIconMode.swift
//  Deflector
//
//  Created by Cizzuk on 2026/09/12.
//

import WidgetKit

class DynamicIslandIconMode {
    static func shouldShowIcon(_ placement: DynamicIslandMode) -> Bool {
        return placementForModel.contains(placement)
    }
    
    static let placementForModel: [DynamicIslandMode] = {
        let model = modelIdentifier
        switch model {
        case "iPhone19,2", "iPhone19,3", "iPhone19,7": // iPhone 18 Pro/Pro Max
            return [.compactLeading, .minimal]
        case "iPhone19,4": // iPhone Duo
            return [.compactLeading, .minimal]
        default:
            return [.minimal]
        }
    }()
    
    private static let modelIdentifier: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let mirror = Mirror(reflecting: systemInfo.machine)
        return mirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    }()
}
