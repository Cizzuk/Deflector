//
//  MainView.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/11.
//

import SwiftUI

@main struct Deflector: App {
    @Environment(\.scenePhase) private var scenePhase

    init() {
        // Initialize Watch Connectivity Service
        _ = WatchConnectivityService.shared
        // Initialize Timer Model
        _ = TimerModel.shared
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .tint(.accent)
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: scenePhase) {
                    if scenePhase == .active {
                        Task {
                            _ = !UserSettings.shared.isSettingsAvailable()
                            await pingAutomationVersionIfNeeded()
                        }
                    }
                }
        }
    }

    private func pingAutomationVersionIfNeeded() async {
        guard UserSettings.shared.deflectorAutomationVersion == 0,
            UserSettings.shared.isFirstSetupCompleted,
            UserSettings.shared.isSettingsAvailable()
        else { return }

        let settings = await UserNotificationSupport.notificationSettings()
        guard UserNotificationSupport.isAlertAvailable(settings: settings) else { return }

        // For update deflectorAutomationVersion
        await SystemCallSupport.addSystemCall(.pingTest)
    }
}

struct MainView: View {
    @State private var path: Route? = {
        if UserSettings.shared.isFirstSetupCompleted {
            return nil
        } else {
            return .firstSetup
        }
    }()
    @State private var isShowingAutomationUpdate = false

    enum Route: Hashable {
        case firstSetup
        case liveActivitySettings, watchSettings, sideButtonSettings, timerSettings
        case about, changeIcon
    }

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.doubleColumn)) {
            List(selection: $path) {
                Section {
                    NavigationLink(value: Route.firstSetup) {
                        VStack(alignment: .leading) {
                            Label("First Setup", systemImage: "gearshape")
                                .font(.title3)
                                .padding(5)
                            Text("If Deflector does not work properly, please try restarting your device or redoing this setup.")
                                .font(.subheadline)

                        }
                    }
                }

                Section {
                    NavigationLink(value: Route.liveActivitySettings) {
                        VStack(alignment: .leading) {
                            Label("Live Activity", systemImage: "clock.badge")
                                .font(.title3)
                                .padding(5)
                            Text("You can set buttons to run shortcuts on the Dynamic Island and the Lock Screen.")
                                .font(.subheadline)
                        }
                    }
                }

                if DeviceInfo.isWatchSupported {
                    Section {
                        NavigationLink(value: Route.watchSettings) {
                            VStack(alignment: .leading) {
                                Label("Apple Watch", systemImage: "applewatch")
                                    .font(.title3)
                                    .padding(5)
                                Text("Run shortcuts on your iPhone from your Apple Watch.")
                                    .font(.subheadline)
                            }
                        }
                    }
                }

                if !DeviceInfo.unsupportedSideButtonAccess {
                    Section {
                        NavigationLink(value: Route.sideButtonSettings) {
                            VStack(alignment: .leading) {
                                Label("Side Button", systemImage: "button.vertical.right")
                                    .font(.title3)
                                    .padding(5)
                                Text("Available only in Japan. You can change the voice assistant assigned to the Side Button. Use a shortcut to access your favorite voice assistant.")
                                    .font(.subheadline)
                            }
                        }
                    }
                }

                Section {
                    NavigationLink(value: Route.timerSettings) {
                        VStack(alignment: .leading) {
                            Label("Timer", systemImage: "timer")
                                .font(.title3)
                                .padding(5)
                            Text("Schedule a shortcut to run later.")
                                .font(.subheadline)
                        }
                    }
                }

                Section {
                    NavigationLink(value: Route.about) {
                        Label("About", systemImage: "info.circle")
                    }
                    if UIApplication.shared.supportsAlternateIcons {
                        NavigationLink(value: Route.changeIcon) {
                            Label("Change App Icon", systemImage: "app.dashed")
                        }
                    }

                }
            }
            .navigationTitle("Deflector")
        } detail: {
            switch path {
            case .firstSetup: FirstSetupView()
            case .liveActivitySettings: LiveActivitySettingsView()
            case .watchSettings: WatchSettingsView()
            case .sideButtonSettings: SideButtonSettingsView()
            case .timerSettings: TimerSettingsView()
            case .about: AboutView()
            case .changeIcon: ChangeIconView()
            case .none: EmptyView()
            }
        }
        .navigationSplitViewStyle(.balanced)
        .sheet(isPresented: $isShowingAutomationUpdate) {
            AutomationUpdateView()
        }
        .onReceive(NotificationCenter.default.publisher(for: .automationUpdateRequested)) { _ in
            isShowingAutomationUpdate = true
        }
        .onOpenURL { url in
            if ["net.cizzuk.deflector", "deflector"].contains(url.scheme) {
                switch url.host {
                case "widget":
                    switch url.path {
                    case "/activity": path = .liveActivitySettings
                    default: break
                    }
                case "open":
                    switch url.path {
                    case "/firstsetup": path = .firstSetup
                    case "/liveactivity": path = .liveActivitySettings
                    case "/watch": path = .watchSettings
                    case "/sidebutton": path = .sideButtonSettings
                    case "/timer": path = .timerSettings
                    default: break
                    }
                default: break
                }
            }
        }
    }
}
