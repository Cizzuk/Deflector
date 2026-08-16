//
//  MianView.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/11.
//

import SwiftUI

@main struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            MianView()
                .tint(.accent)
        }
    }
}

struct MianView: View {
    @StateObject private var userSettings = UserSettings.shared
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: SideButtonSettingsView()) {
                    Label("Side Button", systemImage: "button.vertical.right")
                }
                
                NavigationLink(destination: LiveActivitySettingsView()) {
                    Label("Live Activity", systemImage: "clock.badge")
                }
            }
            .navigationTitle("Deflector")
        }
        .task {
            _ = await UserNotificationSupport.requestAuthorization()
        }
    }
}
