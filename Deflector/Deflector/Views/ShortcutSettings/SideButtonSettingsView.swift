//
//  SideButtonSettingsView.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/11.
//

import SwiftUI

struct SideButtonSettingsView: View {
    @StateObject private var userSettings = UserSettings.shared
    
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
                if OpenSettingsSupport.canOpenSettingsURL {
                    Button(action: { OpenSettingsSupport.openSettingsURL() }) {
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
