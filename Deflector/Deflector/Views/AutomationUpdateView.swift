//
//  AutomationUpdateView.swift
//  Deflector
//
//  Created by Cizzuk on 2026/11/08.
//

import SwiftUI

struct AutomationUpdateView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var testText: LocalizedStringResource = "Not tested yet."
    @State private var testButtonIsActive = true
    @State private var testStatus: TestStatus = .notTested

    private enum TestStatus {
        case notTested
        case testing
        case success
    }

    private func startDeflectorAutomationTest() async {
        UIImpactFeedbackGenerator().impactOccurred()
        testStatus = .testing
        testText = "Waiting for automation response.\nIf there is no response after a few seconds, it may not be configured correctly."
        await SystemCallSupport.addSystemCall(.pingTest)

        // Prevent rapidly tapping
        testButtonIsActive = false
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        testButtonIsActive = true
    }

    private func handleAutomationDetected(_ notification: Notification) {
        guard testStatus == .testing else { return }

        let version = notification.userInfo?["version"] as? Int ?? 0
        if version >= DeflectorAutomationSupport.latestVersion {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            testStatus = .success
            testText = "Test successful! It may be working correctly."
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            testStatus = .notTested
            testText = "Deflector Automation is not the latest version."
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                } header: {
                    Text("Automation Update")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(uiColor: .label))
                        .padding(.top, 35)
                } footer: {
                    Text("You need to update Deflector Automation to use this feature.")
                        .font(.body)
                        .foregroundStyle(Color(uiColor: .label))
                        .padding(.bottom, 20)
                }

                Section {
                    Text("Find Deflector Automation in the Shortcuts app and delete it.")

                    if let url = URL(string: "shortcuts://") {
                        Button(action: { UIApplication.shared.open(url) }) {
                            Label("Open Shortcuts App", systemImage: "square.2.layers.3d")
                        }
                    }
                } header: {
                    Text("1. Delete the existing Deflector Automation")
                }

                Section {
                    Text("Download Deflector Automation from the button below.")

                    Link(destination: DeflectorAutomationSupport.automationURL) {
                        Label("Get Deflector Automation", systemImage: "square.and.arrow.down")
                    }
                    .contextMenu {
                        Button(action: { UIPasteboard.general.string = DeflectorAutomationSupport.automationURL.absoluteString }) {
                            Label("Copy iCloud Sharing Link", systemImage: "icloud.and.arrow.down")
                        }
                        .tint(Color(uiColor: .label))

                        Button(action: { UIPasteboard.general.string = DeflectorAutomationSupport.automationFileURL.absoluteString }) {
                            Label("Copy File Download Link", systemImage: "arrow.down.document")
                        }
                        .tint(Color(uiColor: .label))
                    }
                } header: {
                    Text("2. Download the latest Deflector Automation")
                }

                Section {
                    Button(action: { Task { await startDeflectorAutomationTest() } }) {
                        Label {
                            Text("Run Automation Test")
                        } icon: {
                            switch testStatus {
                            case .notTested: Image(systemName: "play")
                            case .testing: ProgressView().progressViewStyle(.circular)
                            case .success: Image(systemName: "checkmark.circle")
                            }
                        }
                    }
                    .foregroundStyle(.accent)
                    .disabled(!testButtonIsActive)
                } header: {
                    Text("3. Check the Automation Version")
                } footer: {
                    Text(testText)
                        .padding(.bottom, 20)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button("Done", action: { dismiss() })
                        .buttonStyle(.glassProminent)
                        .padding()
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .deflectorAutomationDetected)) { notification in
            handleAutomationDetected(notification)
        }
    }
}
