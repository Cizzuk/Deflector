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
    
    struct ShortcutList: View {
        @Binding var buttons: [DeflectorActivityButton]
        @State private var iconEditActive: Bool = false
        @State private var iconEditorID: UUID? = nil
        @State private var iconEditorText: String = ""
        
        var body: some View {
            ForEach($buttons) { $button in
                HStack(spacing: 10) {
                    UInt32ColorPicker("Color", selection: $button.color)
                        .labelsHidden()
                    
                    Button(action: {
                        iconEditorID = button.id
                        iconEditorText = button.iconName
                        iconEditActive = true
                    }) {
                        Group {
                            if UIImage(systemName: button.iconName) != nil {
                                Label("Icon", systemImage: button.iconName)
                            } else {
                                Label("Icon", systemImage: "questionmark.square.dashed")
                            }
                        }
                        .labelStyle(.iconOnly)
                        .frame(width: 30)
                        .foregroundStyle(Color(uiColor: .label))
                    }
                    .buttonStyle(.borderless)
                    
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
            .sheet(isPresented: $iconEditActive) {
                SymbolPicker(iconEditorText) { symbol in
                    if let id = iconEditorID,
                       let index = buttons.firstIndex(where: { $0.id == id }) {
                        buttons[index].iconName = symbol
                    }
                    iconEditorID = nil
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
            } footer: {
                Text("Live Activity is active for only 8 hours. To display a Live Activity persistently, create an automation in the Shortcuts to start the activity every 8 hours.")
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
            
            Section {
                Toggle(isOn: $userSettings.liveActivityUseBlackBackground) {
                    Text("Use Black Background on Lock Screen")
                }
            }
        }
        .animation(.default, value: vm.isLiveActivityActive)
        .animation(.default, value: userSettings.liveActivityButtons)
        .animation(.default, value: userSettings.liveActivityIslandButtons)
        .animation(.default, value: userSettings.liveActivityUseDifferentOnIsland)
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
