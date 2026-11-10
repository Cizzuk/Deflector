//
//  DeflectorApp.swift
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
