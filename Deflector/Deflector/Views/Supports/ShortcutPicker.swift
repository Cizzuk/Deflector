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
    
    init(
        _ shortcutName: String,
        prompt: LocalizedStringResource? = nil,
        callback: @escaping (String) -> Void
    ) {
        self.shortcutName = shortcutName
        self.prompt = prompt
        self.callback = callback
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
                    Button(action: {
                        isWaitingAutomationCallback = true
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        Task { await ShortcutPickerSupport.callShortcutPicker(prompt: prompt) }
                    }) {
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
            .onAppear() { isFocused = true }
            .onReceive(NotificationCenter.default.publisher(for: .shortcutWasPicked)) { notification in
                if isWaitingAutomationCallback,
                   let userInfo = notification.userInfo,
                   let pickedShortcutName = userInfo["shortcutName"] as? String {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    shortcutName = pickedShortcutName
                    isWaitingAutomationCallback = false
                }
            }
            .navigationTitle("Shortcut")
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        callback(shortcutName)
                        dismiss()
                    }) {
                        Label("Done", systemImage: "checkmark")
                    }
                    .buttonStyle(.glassProminent)
                }
            }
        }
    }
}
