//
//  ShortcutPicker.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/26.
//

import SwiftUI

struct ShortcutPicker: View {
    @Environment(\.dismiss) var dismiss
    
    @State var shortcutName: String
    @State var deviceShortcuts: [String] = []
    var prompt: LocalizedStringResource?
    var callback: (String) -> Void
    
    @State private var searchQuery: String = ""
    @FocusState private var isFocused: Bool
    @State private var disableCallButton: Bool = false
    @State private var isWaitingAutomationCallback: Bool = false
    @State private var errorMessage: LocalizedStringResource?
    
    init(
        _ shortcutName: String,
        prompt: LocalizedStringResource? = nil,
        callback: @escaping (String) -> Void
    ) {
        self.shortcutName = shortcutName
        self.prompt = prompt
        self.callback = callback
    }
    
    private func callDeviceShortcuts() async {
        let settings = await UserNotificationSupport.notificationSettings()
        if !UserNotificationSupport.isAlertAvailable(settings: settings) {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            errorMessage = "Cannot request the shortcut list because notifications are disabled. Please complete the first setup."
            return
        }
        
        isFocused = false
        disableCallButton = true
        isWaitingAutomationCallback = true
        
        UIImpactFeedbackGenerator().impactOccurred()
        await DeviceShortcutsSupport.callDeviceShortcuts()
        
        // Prevent rapidly tapping
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            disableCallButton = false
        }
    }
    
    private func handleDeviceShortcutsNotification(_ notification: Notification) {
        if isWaitingAutomationCallback,
           let userInfo = notification.userInfo,
           let receivedShortcuts = userInfo["shortcuts"] as? [String] {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            deviceShortcuts = receivedShortcuts
            isWaitingAutomationCallback = false
        }
    }
    
    private func close() {
        callback(shortcutName)
        dismiss()
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Shortcut Name", text: $shortcutName)
                        .focused($isFocused)
                        .submitLabel(.done)
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
                            if isWaitingAutomationCallback {
                                ProgressView()
                                    .progressViewStyle(.circular)
                            } else {
                                Image(systemName: "square.2.layers.3d")
                            }
                        }
                    }
                    .foregroundStyle(.accent)
                    .disabled(disableCallButton)
                } footer: {
                    if isWaitingAutomationCallback {
                        Text("Requested the list of shortcuts. If it does not appear, Deflector Automation may not be working correctly.")
                            .padding(.bottom, 10)
                    } else {
                        Text("Use Deflector Automation to request a list of your shortcuts and easily select the one you want.")
                            .padding(.bottom, 10)
                    }
                }

                if !deviceShortcuts.isEmpty {
                    Section {
                        let filteredShortcuts = deviceShortcuts.filter { shortcut in
                            searchQuery.isEmpty || shortcut.localizedCaseInsensitiveContains(searchQuery)
                        }
                        
                        ForEach(filteredShortcuts, id: \.self) { shortcut in
                            let isSelected = shortcutName == shortcut
                            Button(action: { shortcutName = shortcut }) {
                                HStack(spacing: 15) {
                                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(isSelected ? .accent : .secondary)
                                        .accessibilityHidden(true)
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
            .onAppear { isFocused = true }
            .onReceive(NotificationCenter.default.publisher(for: .deviceShortcutsReceived)) { notification in
                handleDeviceShortcutsNotification(notification)
            }
            .searchable(text: $searchQuery, prompt: "Search Shortcuts")
            .searchPresentationToolbarBehavior(.avoidHidingContent)
            .navigationTitle("Shortcut")
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
            .accessibilityAction(.escape) { close() }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { close() }) {
                        Label("Done", systemImage: "checkmark")
                    }
                    .buttonStyle(.glassProminent)
                }
            }
            .alert("Error", isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button("OK", role: .close) { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "")
            }
        }
    }
}
