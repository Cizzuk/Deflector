//
//  MainView.swift
//  Deflector Watch
//
//  Created by Cizzuk on 2026/09/27.
//

import SwiftUI
import WatchConnectivity

@main struct DeflectorWatch: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .tint(.accent)
        }
    }
}

struct MainView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.isLuminanceReduced) private var isLuminanceReduced
    @StateObject private var watchConnectivity = WatchConnectivityService.shared
    @StateObject private var vm = MainViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                if isLuminanceReduced {
                    
                } else if watchConnectivity.activationState != .activated {
                    Section {} footer: {
                        Text("Connection service is not activated.")
                    }
                } else if watchConnectivity.iOSDeviceNeedsUnlockAfterRebootForReachability {
                    Section {} footer: {
                        Text("You need to unlock your iPhone after restarting it.")
                    }
                } else {
                    Section {
                        ForEach(watchConnectivity.receivedApplicationContext.favoriteShortcuts) { shortcut in
                            Button(action: { vm.sendDeflection(shortcut.shortcutName) }) {
                                Label(shortcut.shortcutName, systemImage: shortcut.symbol)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Deflector")
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
}
