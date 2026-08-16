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
    
    struct ShortcutList: View {
        @Binding var buttons: [DeflectorActivityButton]
        
        var body: some View {
            ForEach($buttons) { $button in
                TextField("Shortcut Name", text: $button.shortcutName)
                    .submitLabel(.done)
            }
            .onMove { indices, newOffset in
                buttons.move(fromOffsets: indices, toOffset: newOffset)
            }
            .onDelete { indexSet in
                buttons.remove(atOffsets: indexSet)
            }
            
            if buttons.count < 4 {
                Button(action: {
                    buttons.append(DeflectorActivityButton(shortcutName: ""))
                }) {
                    Label("Add Shortcut", systemImage: "plus")
                }
            }
        }
    }
    
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
                ShortcutList(buttons: $userSettings.liveActivityButtons)
            } header: {
                Text("Shortcuts")
            }
            
            Section {
                Toggle(isOn: $userSettings.liveActivityUseDifferentOnIsland) {
                    Text("Use Different Shortcuts on Dynamic Island")
                }
                
                if userSettings.liveActivityUseDifferentOnIsland {
                    ShortcutList(buttons: $userSettings.liveActivityIslandButtons)
                }
            } header: {
                Text("Dynamic Island")
            }
        }
        .animation(.default, value: userSettings.liveActivityButtons)
        .animation(.default, value: userSettings.liveActivityIslandButtons)
        .animation(.default, value: userSettings.liveActivityUseDifferentOnIsland)
        .navigationTitle("Live Activity")
        .navigationBarTitleDisplayMode(.inline)
    }
}
