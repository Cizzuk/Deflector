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
        @State private var iconEditorID: UUID? = nil
        @State private var iconEditorText: String = ""
        @State private var showIconEditor: Bool = false
        
        var body: some View {
            ForEach($buttons) { $button in
                HStack(spacing: 10) {
                    UInt32ColorPicker("Color", selection: $button.color)
                        .labelsHidden()
                    
                    Button(action: {
                        iconEditorID = button.id
                        iconEditorText = button.iconName
                        showIconEditor = true
                    }) {
                        Label("Icon", systemImage: button.iconName)
                            .labelStyle(.iconOnly)
                            .frame(width: 30)
                            .foregroundStyle(ColorHelper.uInt32ToColor(button.color))
                    }
                    
                    TextField("Shortcut Name", text: $button.shortcutName)
                        .submitLabel(.done)
                }
            }
            .onMove { indices, newOffset in
                buttons.move(fromOffsets: indices, toOffset: newOffset)
            }
            .onDelete { indexSet in
                buttons.remove(atOffsets: indexSet)
            }
            .alert("Please enter a system icon image name", isPresented: $showIconEditor) {
                TextField("Name", text: $iconEditorText)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .submitLabel(.done)
                Button("Cancel", role: .cancel) {
                    iconEditorID = nil
                    iconEditorText = ""
                }
                Button("Done", role: .confirm) {
                    if let id = iconEditorID,
                       let index = buttons.firstIndex(where: { $0.id == id }) {
                        buttons[index].iconName = iconEditorText
                    }
                    iconEditorID = nil
                    iconEditorText = ""
                }
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
                if isActivityActive {
                    Button(action: {
                        DeflectorActivitySupport.endAll()
                        isActivityActive = false
                    }) {
                        Label("End Activity", systemImage: "stop.fill")
                    }
                } else {
                    Button(action: {
                        do {
                            try DeflectorActivitySupport.start()
                            isActivityActive = true
                        } catch {}
                    }) {
                        Label("Start Activity", systemImage: "play.fill")
                    }
                }
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
        .animation(.default, value: isActivityActive)
        .animation(.default, value: userSettings.liveActivityButtons)
        .animation(.default, value: userSettings.liveActivityIslandButtons)
        .animation(.default, value: userSettings.liveActivityUseDifferentOnIsland)
        .navigationTitle("Live Activity")
        .navigationBarTitleDisplayMode(.inline)
    }
}
