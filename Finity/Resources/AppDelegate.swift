//
//  AppDelegate.swift
//  Finity
//
//  Created by Subomi Popoola on 11/18/22.
//

import UIKit
import FirebaseCore
import GoogleSignIn

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled: Bool = GIDSignIn.sharedInstance.handle(url)
        return handled
    }
    
}
