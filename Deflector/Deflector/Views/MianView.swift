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
                .scrollDismissesKeyboard(.interactively)
        }
    }
}

struct MianView: View {
    @State private var path: Route? = {
        if UserSettings.shared.isFirstSetupCompleted {
            return nil
        } else {
            return .firstSetup
        }
    }()
    
    enum Route: Hashable {
        case firstSetup
        case liveActivitySettings, sideButtonSettings
        case about, changeIcon
    }
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.doubleColumn)) {
            List(selection: $path) {
                Section {
                    NavigationLink(value: Route.firstSetup) {
                        VStack(alignment: .leading) {
                            Label("First Setup", systemImage: "gearshape")
                                .font(.title3)
                                .padding(5)
                            Text("If Deflector does not work properly, please try restarting your device and redoing this setup.")
                                .font(.subheadline)
                            
                        }
                    }
                }
                
                Section {
                    NavigationLink(value: Route.liveActivitySettings) {
                        VStack(alignment: .leading) {
                            Label("Live Activity", systemImage: "clock.badge")
                                .font(.title3)
                                .padding(5)
                            Text("You can set buttons to run shortcuts on the Dynamic Island and the Lock Screen.")
                                .font(.subheadline)
                        }
                    }
                }
                
                Section {
                    NavigationLink(value: Route.sideButtonSettings) {
                        VStack(alignment: .leading) {
                            Label("Side Button", systemImage: "button.vertical.right")
                                .font(.title3)
                                .padding(5)
                            Text("Japan-only. You can change the voice assistant assigned to the Side Button. Use a shortcut to access your favorite voice assistant.")
                                .font(.subheadline)
                        }
                    }
                }
                
                Section {
                    NavigationLink(value: Route.about) {
                        Label("About", systemImage: "info.circle")
                    }
                    if UIApplication.shared.supportsAlternateIcons {
                        NavigationLink(value: Route.changeIcon) {
                            Label("Change App Icon", systemImage: "app.dashed")
                        }
                    }
                    
                }
            }
            .navigationTitle("Deflector")
        } detail: {
            switch path {
            case .firstSetup: FirstSetupView()
            case .liveActivitySettings: LiveActivitySettingsView()
            case .sideButtonSettings: SideButtonSettingsView()
            case .about: AboutView()
            case .changeIcon: ChangeIconView()
            case .none: EmptyView()
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
}
