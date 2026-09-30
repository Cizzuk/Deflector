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
    private let wc = WatchConnectivityService.shared
    
    @Published var loading = true
    @Published var shortcuts: [String] = []
    
    @Published var errorMessage: LocalizedStringResource? = nil
    
    func sendDeflection(_ shortcutName: String) {
        WKInterfaceDevice.current().play(.click)
        wc.sendDeflection(shortcutName: shortcutName) { error in
            Task { @MainActor in
                self.errorMessage = SendDeflectionSupport.makeErrorMessage(error: error)
            }
        }
    }
    
    func sendAllShortcutsRequest() {
        WKInterfaceDevice.current().play(.start)
        wc.sendAllShortcutsRequest() { error in
            Task { @MainActor in
                self.errorMessage = "Failed to request the list of all shortcuts."
                self.shortcuts = []
                self.loading = false
            }
        }
    }
    
    func handleDeviceShortcutsNotification(_ notification: Notification) {
        Task { @MainActor in
            if let userInfo = notification.userInfo,
               let receivedShortcuts = userInfo["shortcuts"] as? [String] {
                WKInterfaceDevice.current().play(.stop)
                shortcuts = receivedShortcuts
            }
            loading = false
        }
    }
}
