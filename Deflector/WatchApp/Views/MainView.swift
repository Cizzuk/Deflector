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
                } else if !watchConnectivity.isReachable {
                    if scenePhase == .active {
                        Section {} footer: {
                            Text("Cannot connect to iPhone. Make sure that your iPhone is within range.")
                        }
                    }
                    Section {} footer: {
                        ZStack(alignment: .center) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding()
                                .tint(.white)
                        }
                        .frame(maxWidth: .infinity)
                    }
                } else {
                    Section {
                        ForEach(watchConnectivity.receivedApplicationContext.favoriteShortcuts) { shortcut in
                            Button(action: {
                                watchConnectivity.sendDeflection(shortcutName: shortcut.shortcutName)
                            }) {
                                Label(shortcut.shortcutName, systemImage: shortcut.symbol)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Deflector")
        }
    }
}
