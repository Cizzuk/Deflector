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
    
    func onChange(scenePhase: ScenePhase) {
        switch scenePhase {
        case .active:
            wc.activateSessionIfDeactivated()
            wc.sendResendApplicationContextRequestIfNeeded()
        case .inactive:
            break
        case .background:
            break
        @unknown default:
            break
        }
    }
    
    func sendDeflection(_ shortcutName: String) {
        WKInterfaceDevice.current().play(.click)
        wc.sendDeflection(shortcutName: shortcutName) { error in
            Task { @MainActor in
                self.errorMessage = SendDeflectionSupport.makeErrorMessage(error: error)
            }
        }
    }
}
