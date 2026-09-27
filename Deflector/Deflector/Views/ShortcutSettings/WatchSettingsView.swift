//
//  WatchSettingsView.swift
//  Deflector
//
//  Created by Cizzuk on 2026/09/27.
//

import SwiftUI
import WatchConnectivity

struct WatchSettingsView: View {
    @StateObject private var watchConnectivity = WatchConnectivityService.shared
    
    var body: some View {
        NavigationStack {
            List {
                if watchConnectivity.activationState != .activated {
                    Section {} footer: {
                        Text("Connection service is not activated.")
                    }
                } else if !watchConnectivity.isPaired {
                    Section {} footer: {
                        Text("No Apple Watch is paired with this device.")
                    }
                    
                    if let url = URL(string: "itms-watchs://") {
                        Section {
                            Button(action: { UIApplication.shared.open(url) }) {
                                Label("Open Watch App", systemImage: "applewatch")
                            }
                        }
                    }
                } else if !watchConnectivity.isWatchAppInstalled {
                    Section {} footer: {
                        Text("Deflector is not installed on your Apple Watch. Please install it from the Watch app.")
                    }
                    
                    if let url = URL(string: "itms-watchs://") {
                        Section {
                            Button(action: { UIApplication.shared.open(url) }) {
                                Label("Open Watch App", systemImage: "applewatch")
                            }
                        }
                    }
                } else {
                    // MARK: - Main Watch Settings
                    
                }
            }
            .navigationTitle("Apple Watch")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
