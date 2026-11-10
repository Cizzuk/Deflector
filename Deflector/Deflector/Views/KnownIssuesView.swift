//
//  KnownIssuesView.swift
//  Deflector
//
//  Created by Cizzuk on 2026/09/08.
//

import SwiftUI

struct KnownIssuesView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("The issues listed here are bugs in the Shortcuts app. Because Deflector runs shortcuts through automation, it is affected by these bugs. These issues cannot be fixed in Deflector.")
                }

                Section("Issues") {
                    Text("Automations do not work at all for the first few minutes after the device boots up.")
                    Text("After restarting the device, an automation will not run until the device is unlocked.")
                    Text("When some time has passed since Shortcuts was last opened, the shortcut dialog may stop appearing.")
                    Text("If a shortcut executed from an automation does not finish successfully, automations will not run for a while.")
                    Text("Having too many shortcuts on your device will slow down the execution of automation.")
                }

                Section {
                    Text("There may be various other issues besides these. If an issue caused by a shortcut occurs, waiting for a while before trying again or restarting your device may resolve it.")
                }
            }
            .navigationTitle("Known Issues")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
