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
        }
    }
}

struct MainView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var wc = WatchConnectivityService.shared
    @StateObject private var vm = MainViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                if wc.activationState != .activated {
                    Section {} footer: {
                        Text("Connection service is not activated.")
                    }
                } else if wc.iOSDeviceNeedsUnlockAfterRebootForReachability {
                    Section {} footer: {
                        Text("You need to unlock your iPhone after restarting it.")
                    }
                } else {
                    if wc.receivedApplicationContext.favoriteShortcuts.isEmpty {
                        Section {} footer: {
                            Text("No favorite shortcuts.")
                        }
                        Section {
                            Button(action: { wc.sendResendApplicationContextRequestIfNeeded() }) {
                                Text("Reload Favorite Shortcuts")
                            }
                        }
                    } else {
                        Section {
                            ForEach(wc.receivedApplicationContext.favoriteShortcuts) { shortcut in
                                Button(action: { vm.sendDeflection(shortcut.shortcutName) }) {
                                    Label {
                                        Text(shortcut.shortcutName)
                                    } icon: {
                                        if wc.sentDeflectionShortcuts.contains(shortcut.shortcutName) {
                                            ProgressView()
                                                .progressViewStyle(.circular)
                                                .frame(height: .infinity)
                                        } else {
                                            Image(systemName: shortcut.symbol)
                                        }
                                    }
                                    .lineLimit(2)
                                    .labelStyle(CenteredIconLabelStyle())
                                }
                                .disabled(!wc.isReachable)
                            }
                        }
                    }
                    
                    if wc.receivedApplicationContext.allowShowAllShortcuts {
                        Section {
                            NavigationLink(destination: AllShortcutsView()) {
                                Text("All Shortcuts")
                            }
                            .disabled(!wc.isReachable)
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
