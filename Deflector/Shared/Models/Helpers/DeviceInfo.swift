//
//  DeviceInfo.swift
//  Deflector
//
//  Created by Cizzuk on 2026/09/23.
//

import UIKit

class DeviceInfo {
    static let modelIdentifier: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let mirror = Mirror(reflecting: systemInfo.machine)
        return mirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    }()
    
    enum DynamicIslandType {
        case unknown
        case vertical
        case horizontalSmall
        case horizontal
    }
    
    static let dynamicIslandType: DynamicIslandType = {
        switch modelIdentifier {
        case "iPhone19,4": // iPhone Duo
            return .vertical
        case "iPhone19,2", "iPhone19,3", "iPhone19,7": // iPhone 18 Pro
            return .horizontalSmall
        case "iPhone18,1", "iPhone18,2", "iPhone18,3", "iPhone18,4", // iPhone 17, Air
            "iPhone17,1", "iPhone17,2", "iPhone17,3", "iPhone17,4", // iPhone 16
            "iPhone16,1", "iPhone16,2", "iPhone16,4", "iPhone16,5", // iPhone 15
            "iPhone15,2", "iPhone15,3": // iPhone 14 Pro
            return .horizontal
        default:
            return .unknown
        }
    }()
    
    static let unsupportedSideButtonAccess: Bool = {
        // Not an iPhone
        if UIDevice.current.userInterfaceIdiom != .phone {
            return true
        }
        
        // iPhone SE Gen 2,3
        if ["iPhone14,6", "iPhone12,8"].contains(modelIdentifier) {
            return true
        }
        
        return false
    }()
}
