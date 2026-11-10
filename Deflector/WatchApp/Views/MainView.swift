//
//  MainView.swift
//  Deflector Watch
//
//  Created by Cizzuk on 2026/09/27.
//

import SwiftUI
import WatchConnectivity

@main struct DeflectorWatch: App {
    @Environment(\.scenePhase) private var scenePhase
    static var applicationState: ScenePhase = .active

    init() {
        // Initialize Watch Connectivity Service
        _ = WatchConnectivityService.shared
    }

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .onChange(of: scenePhase) {
            DeflectorWatch.applicationState = scenePhase
            WatchConnectivityService.shared.onChange(scenePhase: scenePhase)
        }
    }
}

struct MainView: View {
    @StateObject private var wc = WatchConnectivityService.shared
    @StateObject private var vm = MainViewModel()

    @State private var inputShortcutName: String?
    @State private var shortcutInput = ""

    var body: some View {
        NavigationStack {
            List {
                if wc.activationState != .activated {
                    Section {
                    } footer: {
                        Text("Connection service is not activated.")
                    }
                } else if wc.iOSDeviceNeedsUnlockAfterRebootForReachability {
                    Section {
                    } footer: {
                        Text("You need to unlock your iPhone after restarting it.")
                    }
                } else {
                    if wc.receivedApplicationContext.favoriteShortcuts.isEmpty {
                        Section {
                        } footer: {
                            Text("No favorite shortcuts.")
                        }
                        Section {
                            Button(action: { wc.sendResendApplicationContextRequestIfNeeded() }) {
                                Text("Reload Favorite Shortcuts")
                            }
                        }
                    } else {
                        Section {
                            ForEach(wc.receivedApplicationContext.favoriteShortcuts) { shortcut in
                                if shortcut.requestType == .input {
                                    TextFieldLink(prompt: Text("Input")) {
                                        shortcutLabel(shortcut)
                                    } onSubmit: { input in
                                        vm.sendDeflection(shortcut.shortcutName, input: input)
                                    }
                                } else {
                                    Button(action: { vm.sendDeflection(shortcut.shortcutName) }) {
                                        shortcutLabel(shortcut)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Deflector")
            .alert(
                "Error",
                isPresented: Binding(
                    get: { vm.errorMessage != nil },
                    set: { if !$0 { Task { @MainActor in vm.errorMessage = nil } } }
                )
            ) {
                Button("OK", role: .close) { vm.errorMessage = nil }
            } message: {
                Text(vm.errorMessage ?? "")
            }
            .sheet(
                isPresented: Binding(
                    get: { inputShortcutName != nil },
                    set: { if !$0 { inputShortcutName = nil } }
                )
            ) {
                // Fallback for Complications
                NavigationStack {
                    List {
                        TextField("Input", text: $shortcutInput)
                            .onSubmit {
                                if !shortcutInput.isEmpty {
                                    if let shortcutName = inputShortcutName {
                                        vm.sendDeflection(shortcutName, input: shortcutInput)
                                    }
                                    self.inputShortcutName = nil
                                }
                            }
                    }
                    .navigationTitle(inputShortcutName ?? "")
                    .onAppear { shortcutInput = "" }
                }
            }
        }
        .onOpenURL { url in
            if ["net.cizzuk.deflector", "deflector"].contains(url.scheme) {
                switch url.host {
                case "widget":
                    switch url.path {
                    case "/deflection":
                        // deflector://widget/deflection?shortcutName=xxx
                        if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems,
                            let shortcutName = queryItems.first(where: { $0.name == "shortcutName" })?.value
                        {
                            let requestType = wc.receivedApplicationContext.favoriteShortcuts
                                .first { $0.shortcutName == shortcutName }?
                                .requestType
                            switch requestType {
                            case .input:
                                inputShortcutName = shortcutName
                            default:
                                vm.sendDeflection(shortcutName)
                            }
                        }
                    default: break
                    }
                default: break
                }
            }
        }
    }

    @ViewBuilder
    private func shortcutLabel(_ shortcut: WCAppContext.FavoriteShortcut) -> some View {
        Label {
            Text(shortcut.shortcutName)
        } icon: {
            if wc.sendingDeflectionShortcut == shortcut.shortcutName {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                Image(systemName: shortcut.symbol)
            }
        }
        .lineLimit(2)
        .labelStyle(CenteredIconLabelStyle())
    }
}
