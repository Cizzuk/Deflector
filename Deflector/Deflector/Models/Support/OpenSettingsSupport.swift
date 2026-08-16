//
//  OpenSettingsSupport.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/17.
//

import UIKit

class OpenSettingsSupport {
    static var canOpenSettingsURL: Bool {
        guard URL(string: UIApplication.openSettingsURLString) != nil else { return false }
        return true
    }
    
    static func openSettingsURL() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL)
    }
}
