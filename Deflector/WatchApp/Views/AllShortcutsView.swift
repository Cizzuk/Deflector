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
    @StateObject private var vm = AllShortcutsViewModel()
    
    var body: some View {
        List {
            if isLuminanceReduced {
                
            } else if vm.loading {
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
                            Text(shortcut)
                                .lineLimit(2)
                        }
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
