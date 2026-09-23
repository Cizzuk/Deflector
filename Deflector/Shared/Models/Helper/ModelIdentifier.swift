//
//  ModelIdentifier.swift
//  Deflector
//
//  Created by Cizzuk on 2026/09/23.
//

import Foundation

let ModelIdentifier: String = {
    var systemInfo = utsname()
    uname(&systemInfo)
    
    let mirror = Mirror(reflecting: systemInfo.machine)
    return mirror.children.reduce("") { identifier, element in
        guard let value = element.value as? Int8, value != 0 else { return identifier }
        return identifier + String(UnicodeScalar(UInt8(value)))
    }
}()
