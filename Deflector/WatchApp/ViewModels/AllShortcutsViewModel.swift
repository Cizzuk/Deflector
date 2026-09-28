//
//  AllShortcutsViewModel.swift
//  Deflector
//
//  Created by Cizzuk on 2026/09/27.
//

import Combine
import SwiftUI
import WatchConnectivity

class AllShortcutsViewModel: ObservableObject {
    private let watchConnectivity = WatchConnectivityService.shared
    
    @Published var loading = true
    @Published var shortcuts: [String] = []
    
    @Published var errorMessage: LocalizedStringResource? = nil
    
    func sendDeflection(_ shortcutName: String) {
        WKInterfaceDevice.current().play(.click)
        watchConnectivity.sendDeflection(shortcutName: shortcutName) { error in
            self.errorMessage = SendDeflectionSupport.makeErrorMessage(error: error)
        }
    }
    
    func sendAllShortcutsRequest() {
        WKInterfaceDevice.current().play(.start)
        watchConnectivity.sendAllShortcutsRequest() { error in
            self.errorMessage = "Failed to request the list of all shortcuts."
            self.shortcuts = []
            self.loading = false
        }
    }
    
    func handleDeviceShortcutsNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let receivedShortcuts = userInfo["shortcuts"] as? [String] {
            WKInterfaceDevice.current().play(.stop)
            shortcuts = receivedShortcuts
        }
        loading = false
    }
}
