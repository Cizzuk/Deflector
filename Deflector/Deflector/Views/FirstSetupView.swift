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
            
            Section {
                Text("Please download the automation shortcut from the link. After that, edit the shortcut and enable the notification automation.")
                
                if let url =  URL(string: "https://cizz.uk/deflector/automation") {
                    Link(destination: url) {
                        Label("Get Automation Shortcut", systemImage: "arrow.down")
                    }
                }
                if let url = URL(string: "shortcuts://") {
                    Button(action: { UIApplication.shared.open(url) }) {
                        Label("Open Shortcuts App", systemImage: "square.2.layers.3d")
                    }
                }
            } header: {
                Label("Automation", systemImage: "square.2.layers.3d")
            }
            
            Section {
                Text("Setup is complete! Return to the screen and start using your favorite shortcuts with Deflector.")
                Text("If it doesn't work properly, please return to this setup and try again.")
            } header: {
                Label("All Done!", systemImage: "checkmark")
            }
        }
        .navigationTitle("First Setup")
        .navigationBarTitleDisplayMode(.inline)
    }
}
