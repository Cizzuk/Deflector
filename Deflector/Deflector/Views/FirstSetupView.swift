//
//  FirstSetupView.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/17.
//

import SwiftUI

struct FirstSetupView: View {
    @State var unAuthorizationStatus: UNAuthorizationStatus?
    
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
                switch unAuthorizationStatus {
                case .authorized: Text("Notifications are allowed.")
                case .notDetermined: EmptyView()
                default: Text("Notifications are denied. Please allow notifications in Settings.")
                }
            }
            .onAppear { updateUNAuthorizationStatus() }
        }
        .navigationTitle("First Setup")
        .navigationBarTitleDisplayMode(.inline)
    }
}
