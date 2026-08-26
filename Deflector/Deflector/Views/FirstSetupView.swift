//
//  FirstSetupView.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/17.
//

import SwiftUI

struct FirstSetupView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var vm = FirstSetupViewModel()
    
    var body: some View {
        List {
            Section {
                Text("Deflector uses Notifications and Automation to run your favorite Shortcuts from Deflector. To do this, you first need to complete a few setup steps.")
            } header: {
                Label("Welcome!", systemImage: "suit.diamond")
            }
            
            // MARK: - Notifications
            
            Section {
                Text("Please allow notifications to run the automation. Next, change the alert settings to Notification Center only.")
                
                if vm.showRequestUNAuthorizationButton {
                    Button(action: { Task { await vm.requestUNAuthorization() } }) {
                        Label("Allow Notifications", systemImage: "bell")
                    }
                }
                
                Button(action: { OpenSettingsSupport.openSettingsURL() }) {
                    Label("Open Settings", systemImage: "gear")
                }
            } header: {
                Label("Notifications", systemImage: "bell")
            } footer: {
                Text(vm.notificationStatusText)
                    .padding(.bottom, 10)
            }
            
            // MARK: - Deflector Automation
            
            Section {
                Text("Please download \"Deflector Automation\", the automation required to run Deflector. Next, edit the shortcut to enable the notification automation.")
                
                if let url =  URL(string: "https://cizz.uk/deflector/automation") {
                    Link(destination: url) {
                        Label("Get Deflector Automation", systemImage: "square.and.arrow.down")
                    }
                }
                
                if let url = URL(string: "shortcuts://") {
                    Button(action: { UIApplication.shared.open(url) }) {
                        Label("Open Shortcuts App", systemImage: "square.2.layers.3d")
                    }
                }
                
                Button(action: { vm.startDeflectorAutomationTest() }) {
                    Label {
                        Text("Run Automation Test")
                    } icon: {
                        switch vm.deflectorAutomationTestStatus {
                        case .notTested: Image(systemName: "play")
                        case .testing: ProgressView().progressViewStyle(.circular)
                        case .success: Image(systemName: "checkmark.circle")
                        }
                    }
                }
                .foregroundStyle(.accent)
                .disabled(!vm.deflectorAutomationTestButtonIsActive)
            } header: {
                Label("Deflector Automation", systemImage: "square.2.layers.3d")
            } footer: {
                Text(vm.deflectorAutomationTestText)
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
        .onChange(of: scenePhase) { vm.onChange(scenePhase: scenePhase) }
        .onReceive(NotificationCenter.default.publisher(for: .pingTestReceived)) { _ in
            vm.handlePingTestReceived()
        }
        .navigationTitle("First Setup")
        .navigationBarTitleDisplayMode(.inline)
    }
}
