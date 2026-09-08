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
                    Text("1. Automations do not work at all for the first few minutes after the device boots up.")
                    Text("2. When some time has passed since Shortcuts was last opened, the shortcut dialog may stop appearing.")
                    Text("3. If a shortcut executed from an automation does not finish successfully, automations will not run for a while.")
                    Text("4. If an error occurs during an automation, such as entering a non-existent shortcut name, the automation may repeatedly trigger errors and become unable to run for a while.")
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
