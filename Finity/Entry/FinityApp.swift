//
//  FinityApp.swift
//  Finity
//
//  Created by Subomi Popoola on 11/16/22.
//

import SwiftUI

@main
struct FinityApp: App {
    
    @StateObject var launchScreenState = LaunchScreenStateManager()
    @StateObject var googleAuthModel = GoogleAuthModel()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if googleAuthModel.isLoggedIn {
                    TimelineView()
                } else {
                    RegistrationView()
                }
    
                if launchScreenState.state != .finished {
                    LaunchScreenView()
                }
            }
            .environmentObject(launchScreenState)
            .environmentObject(googleAuthModel)
        }
    }
}

