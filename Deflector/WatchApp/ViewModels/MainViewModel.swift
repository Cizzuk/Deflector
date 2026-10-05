//
//  MainViewModel.swift
//  Deflector Watch
//
//  Created by Cizzuk on 2026/09/27.
//

import Combine
import SwiftUI
import WatchConnectivity

class MainViewModel: ObservableObject {
    private let wc = WatchConnectivityService.shared
    
    @Published var errorMessage: LocalizedStringResource? = nil
    
    func sendDeflection(_ shortcutName: String) {
        WKInterfaceDevice.current().play(.click)
        wc.sendDeflection(shortcutName: shortcutName) { [weak self] error in
            guard let self, DeflectorWatch.applicationState != .background else { return }
            WKInterfaceDevice.current().play(.failure)
            Task { @MainActor in
                self.errorMessage = SendDeflectionSupport.makeErrorMessage(error: error)
            }
        }
    }
}
