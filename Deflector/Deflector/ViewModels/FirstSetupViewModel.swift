//
//  FirstSetupViewModel.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/26.
//

import Combine
import SwiftUI

class FirstSetupViewModel: ObservableObject {
    @Published var notificationStatusText: LocalizedStringResource = ""
    @Published var showRequestUNAuthorizationButton: Bool = true
    private var unNotificationSettings: UNNotificationSettings?
    
    @Published var deflectorAutomationTestText: LocalizedStringResource = "Not tested yet."
    @Published var deflectorAutomationTestButtonIsActive: Bool = false
    @Published var deflectorAutomationTestStatus: DeflectorAutomationTestStatus = .notTested
    
    enum DeflectorAutomationTestStatus {
        case notTested
        case testing
        case success
    }
    
    init() {
        Task {
            await updateUNAuthorizationStatus()
            resetDeflectorAutomationTest()
        }
    }
    
    // MARK: - Lifecycle
    
    func onChange(scenePhase: ScenePhase) {
        switch scenePhase {
        case .active:
            Task {
                await updateUNAuthorizationStatus()
                resetDeflectorAutomationTest()
            }
        case .inactive:
            break
        case .background:
            break
        @unknown default:
            break
        }
    }
    
    // MARK: - User Notification
    
    func requestUNAuthorization() async {
        _ = await UserNotificationSupport.requestAuthorization()
        await updateUNAuthorizationStatus()
    }
    
    func updateUNAuthorizationStatus() async {
        unNotificationSettings = await UserNotificationSupport.notificationSettings()
        
        switch unNotificationSettings?.authorizationStatus {
        case .authorized:
            showRequestUNAuthorizationButton = false
            UserSettings.shared.isFirstSetupCompleted = true
            
            if unNotificationSettings?.alertSetting == .enabled {
                notificationStatusText = "Notifications are allowed, but banner alerts are enabled. I recommend enabling Notification Center only."
                deflectorAutomationTestButtonIsActive = true
                
            } else if unNotificationSettings?.lockScreenSetting == .enabled {
                notificationStatusText = "Notifications are allowed, but lock screen alerts are enabled. I recommend enabling Notification Center only."
                deflectorAutomationTestButtonIsActive = true
                
            } else if unNotificationSettings?.alertSetting != .enabled && unNotificationSettings?.lockScreenSetting != .enabled && unNotificationSettings?.notificationCenterSetting != .enabled {
                notificationStatusText = "Notifications are allowed, but all alert types are disabled. Please enable Notification Center alert in Settings."
                deflectorAutomationTestButtonIsActive = false
                
            } else {
                notificationStatusText = "Notifications are allowed."
                deflectorAutomationTestButtonIsActive = true
            }
        case .notDetermined:
            showRequestUNAuthorizationButton = true
            notificationStatusText = ""
            deflectorAutomationTestButtonIsActive = false
        default:
            showRequestUNAuthorizationButton = false
            notificationStatusText = "Notifications are disabled. Please allow notifications in Settings."
            deflectorAutomationTestButtonIsActive = false
        }
    }
    
    // MARK: - Deflector Automation Test
    
    func resetDeflectorAutomationTest() {
        deflectorAutomationTestStatus = .notTested
        deflectorAutomationTestText = "Not tested yet."
        deflectorAutomationTestButtonIsActive = UserNotificationSupport.isAlertAvailable(settings: unNotificationSettings)
    }
    
    func startDeflectorAutomationTest() {
        UIImpactFeedbackGenerator().impactOccurred()
        deflectorAutomationTestStatus = .testing
        deflectorAutomationTestText = "Waiting for automation response.\nIf there is no response after a few seconds, it may not be configured correctly."
        deflectorAutomationTestButtonIsActive = false
        Task { await SystemCallSupport.addSystemCall(.pingTest) }
    }

    func handlePingTestReceived() {
        if deflectorAutomationTestStatus == .testing {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            deflectorAutomationTestStatus = .success
            deflectorAutomationTestText = "Test successful! It may be working correctly."
            deflectorAutomationTestButtonIsActive = false
        }
    }
}
