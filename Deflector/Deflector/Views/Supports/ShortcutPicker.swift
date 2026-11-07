//
//  ShortcutPicker.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/26.
//

import SwiftUI

struct ShortcutPicker: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var vm = ShortcutPickerViewModel.shared

    @State var shortcutName: String
    var prompt: LocalizedStringResource?
    var callback: (String) -> Void

    @State private var searchQuery: String = ""
    @State private var disableCallButton = false
    @FocusState private var isFocused: Bool

    init(
        _ shortcutName: String,
        prompt: LocalizedStringResource? = nil,
        callback: @escaping (String) -> Void
    ) {
        self.shortcutName = shortcutName
        self.prompt = prompt
        self.callback = callback
    }

    private func close() {
        callback(shortcutName)
        dismiss()
    }

    private func callDeviceShortcuts() async {
        guard await vm.callDeviceShortcuts() else {
            return
        }

        isFocused = false

        // Prevent rapidly tapping
        disableCallButton = true
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        disableCallButton = false
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Shortcut Name", text: $shortcutName)
                        .focused($isFocused)
                        .submitLabel(.done)
                        .onChange(of: shortcutName) {
                            if shortcutName.count > 1000 {
                                shortcutName = String(shortcutName.prefix(1000))
                            }
                        }
                } header: {
                    Text("Shortcut Name")
                } footer: {
                    if let prompt {
                        Text(prompt)
                            .padding(.bottom, 10)
                    }
                }

                Section {
                    Button(action: { Task { await callDeviceShortcuts() } }) {
                        Label {
                            Text("Get the List of Shortcuts")
                        } icon: {
                            if vm.isWaitingAutomationCallback {
                                ProgressView()
                                    .progressViewStyle(.circular)
                            } else {
                                Image(systemName: "square.2.layers.3d")
                            }
                        }
                    }
                    .foregroundStyle(.accent)
                    .disabled(disableCallButton)
                    .keyboardShortcut("r", modifiers: [.command])
                } footer: {
                    if vm.isWaitingAutomationCallback {
                        Text("Requested the list of shortcuts. If it does not appear, Deflector Automation may not be working correctly.")
                            .padding(.bottom, 10)
                    } else {
                        Text("Use Deflector Automation to request a list of your shortcuts and easily select the one you want.")
                            .padding(.bottom, 10)
                    }
                }

                if !vm.deviceShortcuts.isEmpty {
                    Section {
                        let filteredShortcuts = vm.deviceShortcuts.filter { shortcut in
                            searchQuery.isEmpty || shortcut.localizedCaseInsensitiveContains(searchQuery)
                        }

                        ForEach(filteredShortcuts, id: \.self) { shortcut in
                            let isSelected = shortcutName == shortcut
                            Button(action: { shortcutName = shortcut }) {
                                HStack(spacing: 10) {
                                    if isSelected {
                                        Image(systemName: "checkmark")
                                            .frame(width: 20)
                                            .foregroundStyle(.accent)
                                            .accessibilityHidden(true)
                                    } else {
                                        Spacer().frame(width: 20)
                                    }
                                    Text(shortcut)
                                        .lineLimit(1)
                                        .foregroundStyle(isSelected ? .accent : .primary)
                                }
                            }
                            .accessibilityAddTraits(isSelected ? .isSelected : [])
                        }
                    } header: {
                        Text("Your Shortcuts")
                    }
                }
            }
            .searchable(text: $searchQuery, prompt: "Search Shortcuts")
            .searchPresentationToolbarBehavior(.avoidHidingContent)
            .navigationTitle("Shortcut")
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
            .accessibilityAction(.escape) { close() }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .confirm, action: { close() })
                        .buttonStyle(.glassProminent)
                        .keyboardShortcut(.defaultAction)
                }
            }
            .alert(
                "Error",
                isPresented: Binding(
                    get: { vm.errorMessage != nil },
                    set: { if !$0 { vm.errorMessage = nil } }
                )
            ) {
                Button("OK", role: .close) { vm.errorMessage = nil }
            } message: {
                Text(vm.errorMessage ?? "")
            }
        }
        .onAppear { isFocused = true }
    }
}
