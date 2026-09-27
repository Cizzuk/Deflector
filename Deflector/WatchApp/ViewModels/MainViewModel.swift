//
//  MainViewModel.swift
//  Deflector
//
//  Created by Cizzuk on 2026/09/27.
//

import Combine
import SwiftUI
import WatchConnectivity

class MainViewModel: ObservableObject {
    private let watchConnectivity = WatchConnectivityService.shared
    
    @Published var errorMessage: LocalizedStringResource? = nil
    
    func onChange(scenePhase: ScenePhase) {
        switch scenePhase {
        case .active:
            watchConnectivity.activateSessionIfDeactivated()
            watchConnectivity.sendResendApplicationContextRequestIfNeeded()
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
        watchConnectivity.sendDeflection(shortcutName: shortcutName) { error in
            self.errorMessage = SendDeflectionSupport.makeErrorMessage(error: error)
        }
    }
}
