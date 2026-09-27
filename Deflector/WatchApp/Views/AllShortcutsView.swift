//
//  AllShortcutsView.swift
//  Deflector Watch
//
//  Created by Cizzuk on 2026/09/27.
//

import SwiftUI
import WatchConnectivity

struct AllShortcutsView: View {
    @Environment(\.isLuminanceReduced) private var isLuminanceReduced
    @StateObject private var watchConnectivity = WatchConnectivityService.shared
    @State private var loading = true
    @State private var shortcuts: [String] = []
    
    var body: some View {
        List {
            if isLuminanceReduced {
                
            } else if loading {
                Section {} footer: {
                    ZStack(alignment: .center) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } else {
                Section {
                    ForEach(shortcuts, id: \.self) { shortcut in
                        Button(action: { watchConnectivity.sendDeflection(shortcutName: shortcut) }) {
                            Text(shortcut)
                                .lineLimit(2)
                        }
                    }
                } footer: {
                    if shortcuts.isEmpty {
                        Text("No shortcuts.")
                    }
                }
            }
        }
        .navigationTitle("All Shortcuts")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            watchConnectivity.sendAllShortcutsRequest()
        }
        .onReceive(NotificationCenter.default.publisher(for: .deviceShortcutsReceived)) { notification in
            if let userInfo = notification.userInfo,
               let receivedShortcuts = userInfo["shortcuts"] as? [String] {
                shortcuts = receivedShortcuts
            }
            loading = false
        }
    }
}
