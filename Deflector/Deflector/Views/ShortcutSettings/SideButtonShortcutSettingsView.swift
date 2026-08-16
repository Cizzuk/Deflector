//
//  SideButtonShortcutSettingsView.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/11.
//

import SwiftUI

struct SideButtonShortcutSettingsView: View {
    @StateObject private var userSettings = UserSettings.shared
    
    var body: some View {
        List {
            Section {
                TextField("Shortcut Name", text: $userSettings.sideButtonShortcutName)
            } header: {
                Text("Side Button Shortcut")
            }
        }
        .navigationTitle("Side Button")
        .navigationBarTitleDisplayMode(.inline)
    }
}
