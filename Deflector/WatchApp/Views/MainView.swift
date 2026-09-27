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
                } else if !watchConnectivity.isReachable {
                    Section {} footer: {
                        Text("Cannot connect to iPhone. Make sure that your iPhone is within range.")
                    }
                } else {
                    Section {
                        ForEach(watchConnectivity.receivedApplicationContext.favoriteShortcuts) { shortcut in
                            Button(action: { }) {
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
