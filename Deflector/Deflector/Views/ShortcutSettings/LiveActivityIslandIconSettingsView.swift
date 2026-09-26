//
//  LiveActivityIslandIconSettingsView.swift
//  Deflector
//
//  Created by Cizzuk on 2026/09/23.
//

import SwiftUI
import WidgetKit

struct LiveActivityIslandIconSettingsView: View {
    @StateObject private var userSettings = UserSettings.shared
    
    @State private var isOnCustomize = UserSettings.shared.liveActivityIslandIcons != nil
    @State private var previewModes: [DynamicIslandMode] = []
    
    var body: some View {
        List {
            Section {
                Toggle(isOn: $isOnCustomize) {
                    Text("Customize Dynamic Island Icons")
                }
                .onChange(of: isOnCustomize) {
                    if isOnCustomize {
                        userSettings.liveActivityIslandIcons = .deviceDefault
                    } else {
                        userSettings.liveActivityIslandIcons = nil
                    }
                }
            }
            
            if isOnCustomize {
                Section {} footer: {
                    ZStack(alignment: .center) {
                        DynamicIslandPreview(
                            compactLeading: .constant(userSettings.liveActivityIslandIcons?.compactLeading ?? false),
                            compactTrailing: .constant(userSettings.liveActivityIslandIcons?.compactTrailing ?? false),
                        )
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 10)
                }
                
                Section("Compact") {
                    Toggle(isOn: Binding(
                        get: { userSettings.liveActivityIslandIcons?.compactLeading ?? false },
                        set: { value in userSettings.liveActivityIslandIcons?.compactLeading = value }
                    )) {
                        Text("Leading Icon")
                    }
                    
                    Toggle(isOn: Binding(
                        get: { userSettings.liveActivityIslandIcons?.compactTrailing ?? false },
                        set: { value in userSettings.liveActivityIslandIcons?.compactTrailing = value }
                    )) {
                        Text("Trailing Icon")
                    }
                }
                
                Section("Minimal") {
                    Toggle(isOn: Binding(
                        get: { userSettings.liveActivityIslandIcons?.minimal ?? false },
                        set: { value in userSettings.liveActivityIslandIcons?.minimal = value }
                    )) {
                        Text("Minimal Icon")
                    }
                }
            }
        }
        .animation(.default, value: isOnCustomize)
        .navigationTitle("Dynamic Island Icons")
        .navigationBarTitleDisplayMode(.inline)
    }
}
