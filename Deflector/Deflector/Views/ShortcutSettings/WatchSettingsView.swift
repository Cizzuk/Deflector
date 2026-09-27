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
    
    @State private var favoriteShortcuts: [WCAppContext.FavoriteShortcut] = {
        return WatchConnectivityService.shared.applicationContext.favoriteShortcuts
    }() {
        didSet {
            var context = WatchConnectivityService.shared.applicationContext
            context.favoriteShortcuts = favoriteShortcuts
            try? WatchConnectivityService.shared.updateApplicationContext(context)
        }
    }
    
    @State private var isShowingShortcutPicker = false
    
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
                    Section("Favorite Shortcuts") {
                        ForEach($favoriteShortcuts) { $shortcut in
                            Text(shortcut.shortcutName)
                        }
                        .onMove { indices, newOffset in
                            favoriteShortcuts.move(fromOffsets: indices, toOffset: newOffset)
                        }
                        .onDelete { indexSet in
                            favoriteShortcuts.remove(atOffsets: indexSet)
                        }
                        
                        if favoriteShortcuts.count < 10 {
                            Button(action: { isShowingShortcutPicker = true }) {
                                Label("Add Shortcut", systemImage: "plus")
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $isShowingShortcutPicker) {
                ShortcutPicker(
                    "",
                    prompt: "Please set the shortcut name to add it to your favorites.",
                ) { shortcutName in
                    if !shortcutName.isEmpty && !favoriteShortcuts.contains(where: { $0.shortcutName == shortcutName }) {
                        favoriteShortcuts.append(WCAppContext.FavoriteShortcut(shortcutName: shortcutName))
                    }
                }
            }
            .navigationTitle("Apple Watch")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
