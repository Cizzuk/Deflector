//
//  LiveActivitySettingsView.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/16.
//

import SwiftUI

struct LiveActivitySettingsView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var userSettings = UserSettings.shared
    @StateObject private var vm = LiveActivitySettingsViewModel()
    @State private var iconEditorID: UUID? = nil
    @State private var iconEditorText: String = ""
    @State private var shortcutPickerID: UUID? = nil
    @State private var shortcutPickerText: String = ""
    
    struct ShortcutList: View {
        @Binding var buttons: [DeflectorActivityButton]
        @Binding var iconEditorID: UUID?
        @Binding var iconEditorText: String
        @Binding var shortcutPickerID: UUID?
        @Binding var shortcutPickerText: String
        
        var body: some View {
            ForEach($buttons) { $button in
                HStack(spacing: 10) {
                    UInt32ColorPicker("Color", selection: $button.color)
                        .labelsHidden()
                    
                    Button(action: {
                        iconEditorID = button.id
                        iconEditorText = button.symbol
                    }) {
                        Group {
                            if UIImage(systemName: button.symbol) != nil {
                                Label("Symbol", systemImage: button.symbol)
                            } else {
                                Label("Symbol", systemImage: "questionmark.square.dashed")
                            }
                        }
                        .labelStyle(.iconOnly)
                        .frame(width: 30)
                        .foregroundStyle(Color(uiColor: .label))
                    }
                    .buttonStyle(.borderless)
                    
                    Button(action: {
                        shortcutPickerID = button.id
                        shortcutPickerText = button.shortcutName
                    }) {
                        Text(button.shortcutName.isEmpty ? "Not Set" : button.shortcutName)
                            .foregroundStyle(button.shortcutName.isEmpty ? Color(uiColor: .placeholderText) : Color(uiColor: .label))
                    }
                }
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
    
    // MARK: - View
    var body: some View {
        List {
            Section {
                if vm.isLiveActivityActive {
                    Button(action: { vm.endLiveActivity() }) {
                        Label("End Activity", systemImage: "stop.fill")
                    }
                } else {
                    Button(action: { Task { await vm.startLiveActivity() } }) {
                        Label("Start Activity", systemImage: "play.fill")
                    }
                }
            } header: {
                Text("Activity Control")
            }
            
            Section {
                ShortcutList(
                    buttons: $userSettings.liveActivityButtons,
                    iconEditorID: $iconEditorID,
                    iconEditorText: $iconEditorText,
                    shortcutPickerID: $shortcutPickerID,
                    shortcutPickerText: $shortcutPickerText
                )
            } header: {
                Text("Shortcuts")
            }
            
            Section {
                Toggle(isOn: $userSettings.liveActivityUseDifferentOnIsland) {
                    Text("Use Different Shortcuts on Dynamic Island")
                }
                
                if userSettings.liveActivityUseDifferentOnIsland {
                    ShortcutList(
                        buttons: $userSettings.liveActivityIslandButtons,
                        iconEditorID: $iconEditorID,
                        iconEditorText: $iconEditorText,
                        shortcutPickerID: $shortcutPickerID,
                        shortcutPickerText: $shortcutPickerText
                    )
                }
            } header: {
                Text("Dynamic Island")
            }
            
            Section {
                Toggle(isOn: $userSettings.liveActivityUseBlackBackground) {
                    Text("Use Black Background on Lock Screen")
                }
                Toggle(isOn: $userSettings.liveActivityShowShortcutNames) {
                    Text("Show Shortcut Names")
                }
            }
        }
        .animation(.default, value: vm.isLiveActivityActive)
        .animation(.default, value: userSettings.liveActivityButtons)
        .animation(.default, value: userSettings.liveActivityIslandButtons)
        .animation(.default, value: userSettings.liveActivityUseDifferentOnIsland)
        .sheet(isPresented: .constant(iconEditorID != nil)) {
            SymbolPicker(iconEditorText) { symbol in
                if let iconEditorID  {
                    if let index = userSettings.liveActivityButtons.firstIndex(where: { $0.id == iconEditorID }) {
                        userSettings.liveActivityButtons[index].symbol = symbol
                    } else if let index = userSettings.liveActivityIslandButtons.firstIndex(where: { $0.id == iconEditorID }) {
                        userSettings.liveActivityIslandButtons[index].symbol = symbol
                    }
                }
                iconEditorID = nil
            }
        }
        .sheet(isPresented: .constant(shortcutPickerID != nil)) {
            ShortcutPicker(
                shortcutPickerText,
                prompt: "Please set the shortcut name to run from the Live Activity."
            ) { shortcutName in
                if let shortcutPickerID  {
                    if let index = userSettings.liveActivityButtons.firstIndex(where: { $0.id == shortcutPickerID }) {
                        userSettings.liveActivityButtons[index].shortcutName = shortcutName
                    } else if let index = userSettings.liveActivityIslandButtons.firstIndex(where: { $0.id == shortcutPickerID }) {
                        userSettings.liveActivityIslandButtons[index].shortcutName = shortcutName
                    }
                }
                shortcutPickerID = nil
            }
        }
        .navigationTitle("Live Activity")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: scenePhase) { vm.onChange(scenePhase: scenePhase) }
        .alert("Error", isPresented: .constant(vm.errorMessage != nil)) {
            Button("OK", role: .close) { vm.errorMessage = nil }
        } message: {
            Text(vm.errorMessage ?? "")
        }
    }
}
