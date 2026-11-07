//
//  ShortcutPickerViewModel.swift
//  Deflector
//
//  Created by Cizzuk on 2026/11/07.
//

import Combine
import SwiftUI

class ShortcutPickerViewModel: ObservableObject {
    static let shared = ShortcutPickerViewModel()

    @Published private(set) var deviceShortcuts: [String] = []
    @Published private(set) var isWaitingAutomationCallback = false
    @Published var errorMessage: LocalizedStringResource?

    private var deviceShortcutsObserver: AnyCancellable?

    private init() {
        deviceShortcutsObserver = NotificationCenter.default.publisher(for: .deviceShortcutsReceived)
            .sink { notification in
                Task { @MainActor in
                    ShortcutPickerViewModel.shared.handleDeviceShortcutsNotification(notification)
                }
            }
    }

    // MARK: - Device Shortcuts

    func callDeviceShortcuts() async -> Bool {
        let settings = await UserNotificationSupport.notificationSettings()
        if !UserNotificationSupport.isAlertAvailable(settings: settings) {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            errorMessage = "Cannot request the shortcut list because notifications are disabled. Please complete the first setup."
            return false
        }

        isWaitingAutomationCallback = true

        UIImpactFeedbackGenerator().impactOccurred()
        await DeviceShortcutsSupport.callDeviceShortcuts()
        return true
    }

    private func handleDeviceShortcutsNotification(_ notification: Notification) {
        if isWaitingAutomationCallback,
            let receivedShortcuts = DeviceShortcutsSupport.parseDeviceShortcutsNotification(notification)
        {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            deviceShortcuts = receivedShortcuts
            isWaitingAutomationCallback = false
        }
    }
}
