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
                .onMove { indices, newOffset in
                    userSettings.liveActivityButtons.move(fromOffsets: indices, toOffset: newOffset)
                }
                .onDelete { indexSet in
                    userSettings.liveActivityButtons.remove(atOffsets: indexSet)
                }
                
                if userSettings.liveActivityButtons.count < 4 {
                    Button(action: {
                        userSettings.liveActivityButtons.append(DeflectorActivityButton(shortcutName: ""))
                    }) {
                        Label("Add Shortcut", systemImage: "plus")
                    }
                }
            } header: {
                Text("Shortcuts")
            }
        }
        .animation(.default, value: userSettings.liveActivityButtons)
        .navigationTitle("Live Activity")
        .navigationBarTitleDisplayMode(.inline)
    }
}
