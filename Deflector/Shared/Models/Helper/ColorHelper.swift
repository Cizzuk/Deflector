//
//  ColorHelper.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/14.
//

import SwiftUI

class ColorHelper {
    static func uiColorToUInt32(_ uiColor: UIColor) -> UInt32 {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let r = UInt32(red * 255) << 24
        let g = UInt32(green * 255) << 16
        let b = UInt32(blue * 255) << 8
        let a = UInt32(alpha * 255)
        
        return r | g | b | a
    }
    
    static func uInt32ToColor(_ value: UInt32) -> Color {
        let red = Double((value >> 24) & 0xFF) / 255.0
        let green = Double((value >> 16) & 0xFF) / 255.0
        let blue = Double((value >> 8) & 0xFF) / 255.0
        let alpha = Double(value & 0xFF) / 255.0
        
        return Color(red: red, green: green, blue: blue, opacity: alpha)
    }
    
    static func colorCodeToUInt32(_ string: String) -> UInt32? {
        var hexString = string.uppercased().filter { "0123456789ABCDEF".contains($0) }
        
        guard [3,4,6,8].contains(hexString.count) else { return nil }
        
        if hexString.count == 3 || hexString.count == 4 {
            hexString = hexString.map { "\($0)\($0)" }.joined()
        }
        
        if hexString.count == 6 {
            hexString += "FF"
        }
        
        return UInt32(hexString, radix: 16)
    }
}
