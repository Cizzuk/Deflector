//
//  SideButtonSettingsView.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/11.
//

import SwiftUI

struct SideButtonSettingsView: View {
    @StateObject private var userSettings = UserSettings.shared
    @State private var isShowingShortcutPicker = false
    
    var body: some View {
        List {
            Section {
                Button(action: { isShowingShortcutPicker = true }) {
                    if userSettings.sideButtonShortcutName.isEmpty {
                        Label {
                            Text("Not Set")
                                .foregroundStyle(Color(uiColor: UIColor.placeholderText))
                        } icon: {
                            Image(systemName: "square.2.layers.3d")
                        }
                    } else {
                        Label(userSettings.sideButtonShortcutName, systemImage: "square.2.layers.3d")
                    }
                }
                .foregroundStyle(Color(uiColor: UIColor.label))
            } header: {
                Text("Select Shortcut")
            } footer: {
                Text("Please set the shortcut name to launch the voice assistant.")
            }
            
            Section {
                if OpenSettingsSupport.canOpenSettingsURL {
                    Button(action: { OpenSettingsSupport.openSettingsURL() }) {
                        Label("Open Settings", systemImage: "gear")
                    }
                }
            } footer: {
                Text("Please turn on \"Press Side Button for Deflector\" in the Settings. To run the shortcut from the Side Button, the device must be physically located in a region that supports [Side Button Access](https://developer.apple.com/documentation/appintents/launching-your-voice-based-conversational-app-from-the-side-button-of-iphone).")
            }
        }
        .sheet(isPresented: $isShowingShortcutPicker) {
            ShortcutPicker(
                userSettings.sideButtonShortcutName,
                prompt: "Please set the shortcut name to launch the voice assistant."
            ) { shortcutName in
                userSettings.sideButtonShortcutName = shortcutName
            }
        }
        .navigationTitle("Side Button")
        .navigationBarTitleDisplayMode(.inline)
    }
}
