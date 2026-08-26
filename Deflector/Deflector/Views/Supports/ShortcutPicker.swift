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
    var prompt: LocalizedStringResource?
    var callback: (String) -> Void
    
    @FocusState private var isFocused: Bool
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
    
    private func callShortcutPicker() async {
        let settings = await UserNotificationSupport.notificationSettings()
        if !UserNotificationSupport.isAlertAvailable(settings: settings) {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            errorMessage = "Cannot display the shortcut list because notifications are disabled. Please complete the first setup."
            return
        }
        
        isWaitingAutomationCallback = true
        UIImpactFeedbackGenerator().impactOccurred()
        await ShortcutPickerSupport.callShortcutPicker(prompt: prompt)
    }
    
    private func handleShortcutPickNotification(_ notification: Notification) {
        if isWaitingAutomationCallback,
           let userInfo = notification.userInfo,
           let pickedShortcutName = userInfo["shortcutName"] as? String {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            shortcutName = pickedShortcutName
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
                    }
                }
                
                Section {
                    Button(action: { Task { await callShortcutPicker() } }) {
                        Label("Choose from the list of shortcuts", systemImage: "square.2.layers.3d")
                    }
                } footer: {
                    if isWaitingAutomationCallback {
                        Text("Requested to display the shortcut list. If it does not appear, Deflector Automation may not be working correctly.")
                    } else {
                        Text("Use Deflector Automation to display a list of your shortcuts and easily select the one you want.")
                    }
                }
            }
            .onAppear { isFocused = true }
            .onReceive(NotificationCenter.default.publisher(for: .shortcutWasPicked)) { notification in
                handleShortcutPickNotification(notification)
            }
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
            .alert("Error", isPresented: .constant(errorMessage != nil)) {
                Button("OK", role: .close) { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "")
            }
        }
    }
}
