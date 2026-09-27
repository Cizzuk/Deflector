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
    @State private var symbolPickerID: String? = nil
    @State private var symbolPickerText: String = ""
    
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
                            HStack(spacing: 18) {
                                Button(action: {
                                    symbolPickerID = shortcut.id
                                    symbolPickerText = shortcut.symbol
                                }) {
                                    Label {
                                        Text("Symbol")
                                    } icon: {
                                        SymbolHelper.getSymbolImage(shortcut.symbol).image
                                            .font(.system(size: 20, weight: .regular))
                                            .foregroundColor(Color(uiColor: .label))
                                    }
                                    .frame(width: 24, height: 24)
                                    .labelStyle(.iconOnly)
                                }
                                .buttonStyle(.borderless)
                                
                                Text(shortcut.shortcutName)
                                    .lineLimit(1)
                            }
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
            .sheet(isPresented: Binding(
                get: { symbolPickerID != nil },
                set: { if !$0 { symbolPickerID = nil } }
            )) {
                SymbolPicker(symbolPickerText, showCustomSymbols: false) { symbol in
                    if let symbolPickerID,
                       let index = favoriteShortcuts.firstIndex(where: { $0.id == symbolPickerID }) {
                        favoriteShortcuts[index].symbol = symbol
                    }
                    symbolPickerID = nil
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
