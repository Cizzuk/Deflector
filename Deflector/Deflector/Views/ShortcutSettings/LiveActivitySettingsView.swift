//
//  LiveActivitySettingsView.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/16.
//

import SwiftUI

struct LiveActivitySettingsView: View {
    @StateObject private var userSettings = UserSettings.shared
    @State private var isActivityActive: Bool = DeflectorActivitySupport.isActive()
    
    var body: some View {
        List {
            Section {
                Button(action: {
                    do {
                        try DeflectorActivitySupport.start()
                        isActivityActive = true
                    } catch {}
                }) {
                    Label("Start Activity", systemImage: "play.fill")
                }
                .disabled(isActivityActive)
                
                Button(action: {
                    DeflectorActivitySupport.endAll()
                    isActivityActive = false
                }) {
                    Label("End Activity", systemImage: "stop.fill")
                }
                .disabled(!isActivityActive)
            } header: {
                Text("Activity Controls")
            }
            
            Section {
                ForEach($userSettings.liveActivityButtons) { $button in
                    TextField("Shortcut Name", text: $button.shortcutName)
                        .submitLabel(.done)
                }
            } header: {
                Text("Shortcuts")
            }
        }
        .navigationTitle("Live Activity")
        .navigationBarTitleDisplayMode(.inline)
    }
}
