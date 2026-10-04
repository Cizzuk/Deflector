//
//  AllShortcutsView.swift
//  Deflector Watch
//
//  Created by Cizzuk on 2026/09/27.
//

import SwiftUI
import WatchConnectivity

struct AllShortcutsView: View {
    @StateObject private var wc = WatchConnectivityService.shared
    @StateObject private var vm = AllShortcutsViewModel()
    
    var body: some View {
        List {
            if vm.loading {
                Section {} footer: {
                    ZStack(alignment: .center) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } else {
                Section {
                    ForEach(vm.shortcuts, id: \.self) { shortcut in
                        Button(action: { vm.sendDeflection(shortcut) }) {
                            Label {
                                Text(shortcut)
                            } icon: {
                                if wc.sentDeflectionShortcuts.contains(shortcut) {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .frame(height: .infinity)
                                } else {
                                    Image(systemName: "square.2.layers.3d.fill")
                                }
                            }
                            .lineLimit(2)
                            .labelStyle(CenteredIconLabelStyle())
                        }
                        .disabled(!wc.isReachable)
                    }
                } footer: {
                    if vm.shortcuts.isEmpty {
                        Text("No shortcuts.")
                    }
                }
            }
        }
        .navigationTitle("All Shortcuts")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error", isPresented: Binding(
            get: { vm.errorMessage != nil },
            set: { if !$0 { vm.errorMessage = nil } }
        )) {
            Button("OK", role: .close) { vm.errorMessage = nil }
        } message: {
            Text(vm.errorMessage ?? "")
        }
        .onAppear { vm.sendAllShortcutsRequest() }
        .onReceive(NotificationCenter.default.publisher(for: .deviceShortcutsReceived)) { notification in
            vm.handleDeviceShortcutsNotification(notification)
        }
    }
}
