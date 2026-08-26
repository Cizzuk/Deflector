//
//  FirstSetupView.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/17.
//

import SwiftUI

struct FirstSetupView: View {
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var unAuthorizationStatus: UNAuthorizationStatus?
    @State private var deflectorAutomationTest: DeflectorAutomationTestResult = .notTested
    
    enum DeflectorAutomationTestResult {
        case notTested
        case testing
        case success
    }
    
    private func requestUNAuthorization() {
        Task {
            _ = await UserNotificationSupport.requestAuthorization()
            unAuthorizationStatus = await UserNotificationSupport.authorizationStatus()
        }
    }
    
    private func updateUNAuthorizationStatus() {
        Task {
            unAuthorizationStatus = await UserNotificationSupport.authorizationStatus()
        }
    }
    
    var body: some View {
        List {
            Section {
                Text("Deflector uses Notifications and Automation to run your favorite Shortcuts from Deflector. To do this, you first need to complete a few setup steps.")
            } header: {
                Label("Welcome!", systemImage: "suit.diamond")
            }
            
            // MARK: - Notifications
            
            Section {
                Text("Please allow notifications. After that, I recommend changing the settings to show Alerts only in the Notification Center.")
                
                if unAuthorizationStatus == .notDetermined {
                    Button(action: { requestUNAuthorization() }) {
                        Label("Allow Notifications", systemImage: "bell")
                    }
                }
                
                Button(action: { OpenSettingsSupport.openSettingsURL() }) {
                    Label("Open Settings", systemImage: "gear")
                }
            } header: {
                Label("Notifications", systemImage: "bell")
            } footer: {
                Group {
                    switch unAuthorizationStatus {
                    case .authorized: Text("Notifications are allowed.")
                    case .notDetermined: EmptyView()
                    default: Text("Notifications are denied. Please allow notifications in Settings.")
                    }
                }
                .padding(.bottom, 10)
            }
            
            // MARK: - Deflector Automation
            
            Section {
                Text("Please download \"Deflector Automation\", the automation required to run Deflector. Then, edit the shortcut to enable the notification automation.")
                
                if let url =  URL(string: "https://cizz.uk/deflector/automation") {
                    Link(destination: url) {
                        Label("Get Deflector Automation", systemImage: "arrow.down")
                    }
                }
                
                if let url = URL(string: "shortcuts://") {
                    Button(action: { UIApplication.shared.open(url) }) {
                        Label("Open Shortcuts App", systemImage: "square.2.layers.3d")
                    }
                }
                
                Button(action: {
                    deflectorAutomationTest = .testing
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    Task { await SystemCallSupport.addSystemCall(.pingTest) }
                }) {
                    Label {
                        Text("Run Automation Test")
                    } icon: {
                        switch deflectorAutomationTest {
                        case .notTested: Image(systemName: "play")
                        case .testing: ProgressView().progressViewStyle(.circular)
                        case .success: Image(systemName: "checkmark.seal")
                        }
                    }
                }
                .foregroundStyle(.accent)
                .disabled(deflectorAutomationTest != .notTested)
            } header: {
                Label("Deflector Automation", systemImage: "square.2.layers.3d")
            } footer: {
                Group {
                    switch deflectorAutomationTest {
                    case .notTested: Text("Not tested yet.")
                    case .testing: Text("Waiting for automation response.\nIf there is no response after a few seconds, it may not be configured correctly.")
                    case .success: Text("Test successful! It may be working correctly.")
                    }
                }
                .padding(.bottom, 10)
            }
            
            // MARK: - All Done!
            
            Section {
                Text("Setup is complete! You can now assign and run your favorite shortcuts for Live Activities or Side Button.")
                Text("If it doesn't work properly, please return to this setup and try again.")
                Text("If shortcuts or automations are not working properly, restarting your device may resolve the issue.")
            } header: {
                Label("All Done!", systemImage: "checkmark")
            }
        }
        .onAppear { updateUNAuthorizationStatus() }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                updateUNAuthorizationStatus()
                deflectorAutomationTest = .notTested
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .pingTestReceived)) { _ in
            if deflectorAutomationTest == .testing {
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                deflectorAutomationTest = .success
            }
        }
        .navigationTitle("First Setup")
        .navigationBarTitleDisplayMode(.inline)
    }
}
