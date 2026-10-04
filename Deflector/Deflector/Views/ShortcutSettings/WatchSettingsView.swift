//
//  WatchSettingsView.swift
//  Deflector
//
//  Created by Cizzuk on 2026/09/27.
//

import SwiftUI
import WatchConnectivity

struct WatchSettingsView: View {
    @StateObject private var wc = WatchConnectivityService.shared
    
    @State private var isShowingShortcutPicker = false
    @State private var symbolPickerID: String? = nil
    @State private var symbolPickerText: String = ""
    
    @State private var context = WatchConnectivityService.shared.applicationContext
    
    var body: some View {
        NavigationStack {
            List {
                if wc.activationState != .activated {
                    Section {} footer: {
                        Text("Connection service is not activated.")
                    }
                } else if !wc.isPaired {
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
                } else if !wc.isWatchAppInstalled {
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
                        ForEach($context.favoriteShortcuts) { $shortcut in
                            HStack(spacing: 18) {
                                Button(action: {
                                    symbolPickerID = shortcut.id
                                    symbolPickerText = shortcut.symbol
                                }) {
                                    Label {
                                        Text("Symbol")
                                    } icon: {
                                        let symbolImage = SymbolHelper.getSymbolImage(shortcut.symbol, allowCustom: false)
                                        symbolImage.image?
                                            .font(.system(size: 20, weight: .regular))
                                            .foregroundStyle(Color(uiColor: symbolImage.type == .none ? .placeholderText : .label))
                                    }
                                    .frame(width: 24, height: 24)
                                    .labelStyle(.iconOnly)
                                }
                                .buttonStyle(.borderless)
                                .accessibilityValue(shortcut.symbol.isEmpty ? "Not Set" : shortcut.symbol)
                                
                                Text(shortcut.shortcutName)
                                    .lineLimit(1)
                            }
                            .accessibilityElement(children: .contain)
                            .accessibilityLabel(shortcut.shortcutName.isEmpty ? "Not Set" : shortcut.shortcutName)
                        }
                        .onMove { indices, newOffset in
                            context.favoriteShortcuts.move(fromOffsets: indices, toOffset: newOffset)
                        }
                        .onDelete { indexSet in
                            context.favoriteShortcuts.remove(atOffsets: indexSet)
                        }
                        
                        if context.favoriteShortcuts.count < 10 {
                            Button(action: { isShowingShortcutPicker = true }) {
                                Label("Add Shortcut", systemImage: "plus")
                            }
                            .keyboardShortcut("n", modifiers: [.command])
                        }
                    }
                    
                    Section {
                        Toggle("Show All Shortcuts", isOn: $context.allowShowAllShortcuts)
                    }
                    
                    Section {} footer: {
                        Text("If you cannot run the shortcut, please make sure that Deflector Automation is allowed to run when locked, and that your Apple Watch and iPhone are within communication range.")
                    }
                }
            }
            .navigationTitle("Apple Watch")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: Binding(
                get: { symbolPickerID != nil },
                set: { if !$0 { symbolPickerID = nil } }
            )) {
                SymbolPicker(symbolPickerText, showCustomSymbols: false) { symbol in
                    if let symbolPickerID,
                       let index = context.favoriteShortcuts
                        .firstIndex(where: { $0.id == symbolPickerID }) {
                        context.favoriteShortcuts[index].symbol = symbol
                    }
                    symbolPickerID = nil
                }
            }
            .sheet(isPresented: $isShowingShortcutPicker) {
                ShortcutPicker(
                    "",
                    prompt: "Please set the shortcut name to add it to your favorites.",
                ) { shortcutName in
                    if !shortcutName.isEmpty && !context.favoriteShortcuts.contains(where: { $0.shortcutName == shortcutName }) {
                        context.favoriteShortcuts.append(WCAppContext.FavoriteShortcut(shortcutName: shortcutName))
                    }
                }
            }
        }
        .onChange(of: context) {
            try? wc.updateApplicationContext(context)
        }
        .onReceive(NotificationCenter.default.publisher(for: .watchConnectivityApplicationContextDidChange)) { _ in
            context = wc.applicationContext
        }
    }
}
