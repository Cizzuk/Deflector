//
//  MainView.swift
//  Deflector Watch
//
//  Created by Cizzuk on 2026/09/27.
//

import SwiftUI

@main struct DeflectorWatch: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .tint(.accent)
        }
    }
}

struct MainView: View {
    @StateObject private var watchConnectivity = WatchConnectivityService.shared
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(watchConnectivity.receivedApplicationContext.favoriteShortcuts) { shortcut in
                        Button(action: { }) {
                            Text(shortcut.shortcutName)
                        }
                    }
                }
            }
            .navigationTitle("Deflector")
        }
    }
}
