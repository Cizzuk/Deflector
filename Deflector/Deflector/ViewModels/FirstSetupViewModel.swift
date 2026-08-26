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
    private var unAuthorizationStatus: UNAuthorizationStatus?
    
    @Published var deflectorAutomationTestText: LocalizedStringResource = "Not tested yet."
    @Published var deflectorAutomationTestButtonIsActive: Bool = true
    @Published var deflectorAutomationTestStatus: DeflectorAutomationTestStatus = .notTested
    
    enum DeflectorAutomationTestStatus {
        case notTested
        case testing
        case success
    }
    
    init() {
        Task { await updateUNAuthorizationStatus() }
    }
    
    // MARK: - Lifecycle
    
    func onChange(scenePhase: ScenePhase) {
        switch scenePhase {
        case .active:
            Task { await updateUNAuthorizationStatus() }
            resetDeflectorAutomationTest()
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
        unAuthorizationStatus = await UserNotificationSupport.authorizationStatus()
    }
    
    func updateUNAuthorizationStatus() async {
        unAuthorizationStatus = await UserNotificationSupport.authorizationStatus()
        switch unAuthorizationStatus {
        case .authorized:
            notificationStatusText = "Notifications are allowed."
            showRequestUNAuthorizationButton = false
        case .notDetermined:
            notificationStatusText = ""
            showRequestUNAuthorizationButton = true
        default:
            notificationStatusText = "Notifications are denied. Please allow notifications in Settings."
            showRequestUNAuthorizationButton = false
        }
    }
    
    // MARK: - Deflector Automation Test
    
    func resetDeflectorAutomationTest() {
        deflectorAutomationTestStatus = .notTested
        deflectorAutomationTestText = "Not tested yet."
        deflectorAutomationTestButtonIsActive = true
    }
    
    func startDeflectorAutomationTest() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
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
