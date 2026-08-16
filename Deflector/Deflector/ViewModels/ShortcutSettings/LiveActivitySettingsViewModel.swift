//
//  LiveActivitySettingsViewModel.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/16.
//

import ActivityKit
import Combine
import Foundation

class LiveActivitySettingsViewModel: ObservableObject {
    @Published var errorMessage: LocalizedStringResource? = nil
    @Published var isLiveActivityActive: Bool = DeflectorActivitySupport.isActive()
    
    func startLiveActivity() {
        do {
            try DeflectorActivitySupport.start()
            isLiveActivityActive = true
        } catch let error as ActivityAuthorizationError {
            switch error {
            case .attributesTooLarge:
                errorMessage = "Unable to start the activity because the data of the shortcuts are too large."
            case .denied:
                errorMessage = "Unable to start the activity because Live Activities are disabled in Settings."
            case .globalMaximumExceeded:
                errorMessage = "Unable to start the activity because the device has reached its maximum limit of activities."
            case .targetMaximumExceeded:
                errorMessage = "Unable to start the activity because Deflector has reached its maximum limit of activities."
            default:
                errorMessage = "Failed to start Live Activity: \(error.localizedDescription)"
            }
        } catch {
            errorMessage = "Failed to start Live Activity: \(error.localizedDescription)"
        }
    }
    
    func endLiveActivity() {
        DeflectorActivitySupport.endAll()
        isLiveActivityActive = false
    }
}
