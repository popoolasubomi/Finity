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
                    TabView {
                        TimelineView()
                            .tabItem {
                                Image(Asset.HOME_ICON.rawValue)
                            }
                        EventsView()
                            .tabItem {
                                Image(Asset.EVENT_ICON.rawValue)
                            }
                        ProfileView()
                            .tabItem {
                                Image(Asset.PROFILE_ICON.rawValue)
                            }
                    }
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

