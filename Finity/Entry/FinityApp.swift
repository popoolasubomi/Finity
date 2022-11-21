//
//  FinityApp.swift
//  Finity
//
//  Created by Subomi Popoola on 11/16/22.
//

import SwiftUI
import XNavigation

@main
struct FinityApp: App {
    
    @StateObject var launchScreenState = LaunchScreenStateManager()
    @StateObject var googleAuthModel = GoogleAuthModel()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            WindowReader { window in
                ZStack {
                    if googleAuthModel.isLoggedIn {
                        TabView {
                            TimelineView()
                                .environmentObject(Navigation(window: window!))
                                .tabItem {
                                    Image(Asset.HOME_ICON.rawValue)
                                }
                            EventsView()
                                .tabItem {
                                    Image(Asset.EVENT_ICON.rawValue)
                                }
                            ProfileView()
                                .environmentObject(Navigation(window: window!))
                                .tabItem {
                                    Image(Asset.PROFILE_ICON.rawValue)
                                }
                        }
                    } else {
                        RegistrationView()
                            .environmentObject(launchScreenState)
                            .environmentObject(googleAuthModel)
                    }
        
                    if launchScreenState.state != .finished {
                        LaunchScreenView()
                            .environmentObject(launchScreenState)
                    }
                }
            }
        }
    }
}

