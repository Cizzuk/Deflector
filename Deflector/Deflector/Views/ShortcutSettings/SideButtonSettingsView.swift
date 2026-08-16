//
//  SideButtonSettingsView.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/11.
//

import SwiftUI

struct SideButtonSettingsView: View {
    @StateObject private var userSettings = UserSettings.shared
    
    private var canOpenSettingsURL: Bool {
        guard URL(string: UIApplication.openSettingsURLString) != nil else { return false }
        return true
    }
    
    private func openSettingsURL() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL)
    }
    
    var body: some View {
        List {
            Section {
                TextField("Shortcut Name", text: $userSettings.sideButtonShortcutName)
                    .submitLabel(.done)
            } header: {
                Text("Side Button Shortcut")
            } footer: {
                Text("Please enter the name of the shortcut to launch the voice assistant.")
            }
            
            Section {
                if canOpenSettingsURL {
                    Button(action: { openSettingsURL() }) {
                        Label("Open Settings", systemImage: "gear")
                    }
                }
            } footer: {
                Text("Please set Deflector to the Side Button in Settings.")
            }
        }
        .navigationTitle("Side Button")
        .navigationBarTitleDisplayMode(.inline)
    }
}
