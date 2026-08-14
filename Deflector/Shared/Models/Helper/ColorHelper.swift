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
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        let r = UInt32(red * 255) << 24
        let g = UInt32(green * 255) << 16
        let b = UInt32(blue * 255) << 8
        
        return r | g | b
    }
    
    static func uInt32ToColor(_ value: UInt32) -> Color {
        let red = Double((value >> 24) & 0xFF) / 255.0
        let green = Double((value >> 16) & 0xFF) / 255.0
        let blue = Double((value >> 8) & 0xFF) / 255.0
        
        return Color(red: red, green: green, blue: blue)
    }
}
