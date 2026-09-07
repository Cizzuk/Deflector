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
    @State private var symbolPickerID: UUID? = nil
    @State private var symbolPickerText: String = ""
    @State private var shortcutPickerID: UUID? = nil
    @State private var shortcutPickerText: String = ""
    
    struct ShortcutList: View {
        @Binding var buttons: [DeflectorActivityButton]
        @Binding var symbolPickerID: UUID?
        @Binding var symbolPickerText: String
        @Binding var shortcutPickerID: UUID?
        @Binding var shortcutPickerText: String
        
        var body: some View {
            ForEach($buttons) { $button in
                HStack(spacing: 10) {
                    UInt32ColorPicker("Color", selection: $button.color)
                        .labelsHidden()
                    
                    Button(action: {
                        symbolPickerID = button.id
                        symbolPickerText = button.symbol
                    }) {
                        Label {
                            Text("Symbol")
                        } icon: {
                            let symbolImage = SymbolHelper.getSymbolImage(button.symbol)
                            if symbolImage.type.isPicture {
                                symbolImage.image?
                                    .resizable()
                                    .scaledToFit()
                            } else {
                                symbolImage.image?
                                    .font(.system(size: 20, weight: .regular))
                                    .foregroundStyle(Color(uiColor: symbolImage.type == .none ? .placeholderText : .label))
                            }
                        }
                        .frame(width: 24, height: 24)
                        .labelStyle(.iconOnly)
                        .padding(.horizontal, 8)
                    }
                    .buttonStyle(.borderless)
                    
                    Button(action: {
                        shortcutPickerID = button.id
                        shortcutPickerText = button.shortcutName
                    }) {
                        Text(button.shortcutName.isEmpty ? String(localized: "Not Set") : button.shortcutName)
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
            } footer: {
                Text("Activities appear on the Lock Screen and in the Dynamic Island. To use a shortcut from the Dynamic Island, touch and hold it.")
                    .padding(.bottom, 10)
            }
            
            Section {
                ShortcutList(
                    buttons: $userSettings.liveActivityButtons,
                    symbolPickerID: $symbolPickerID,
                    symbolPickerText: $symbolPickerText,
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
                        symbolPickerID: $symbolPickerID,
                        symbolPickerText: $symbolPickerText,
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
        .sheet(isPresented: Binding(
            get: { symbolPickerID != nil },
            set: { if !$0 { symbolPickerID = nil } }
        )) {
            SymbolPicker(symbolPickerText) { symbol in
                if let symbolPickerID  {
                    if let index = userSettings.liveActivityButtons.firstIndex(where: { $0.id == symbolPickerID }) {
                        userSettings.liveActivityButtons[index].symbol = symbol
                    } else if let index = userSettings.liveActivityIslandButtons.firstIndex(where: { $0.id == symbolPickerID }) {
                        userSettings.liveActivityIslandButtons[index].symbol = symbol
                    }
                }
                symbolPickerID = nil
            }
        }
        .sheet(isPresented: Binding(
            get: { shortcutPickerID != nil },
            set: { if !$0 { shortcutPickerID = nil } }
        )) {
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
        .alert("Error", isPresented: Binding(
            get: { vm.errorMessage != nil },
            set: { if !$0 { vm.errorMessage = nil } }
        )) {
            Button("OK", role: .close) { vm.errorMessage = nil }
        } message: {
            Text(vm.errorMessage ?? "")
        }
    }
}
