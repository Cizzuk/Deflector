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
                .scrollDismissesKeyboard(.interactively)
                .tint(.accent)
        }
    }
}

struct MianView: View {
    @StateObject private var userSettings = UserSettings.shared
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink(destination: FirstSetupView()) {
                        VStack(alignment: .leading) {
                            Label("First Setup", systemImage: "gearshape")
                                .font(.title3)
                                .padding(5)
                                .padding(.bottom, 5)
                            Text("To run shortcuts using Deflector, you need to set up an automation in the Shortcuts app.")
                                .font(.subheadline)
                            
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: LiveActivitySettingsView()) {
                        VStack(alignment: .leading) {
                            Label("Live Activity", systemImage: "clock.badge")
                                .font(.title3)
                                .padding(5)
                                .padding(.bottom, 5)
                            Text("You can set buttons to run shortcuts on the Dynamic Island and the Lock Screen.")
                                .font(.subheadline)
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: SideButtonSettingsView()) {
                        VStack(alignment: .leading) {
                            Label("Side Button", systemImage: "button.vertical.right")
                                .font(.title3)
                                .padding(5)
                                .padding(.bottom, 5)
                            Text("Japan-only. You can change the voice assistant assigned to the Side Button. Use a shortcut to access your favorite voice assistant.")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("Deflector")
        }
        .task {
            _ = await UserNotificationSupport.requestAuthorization()
        }
    }
}
