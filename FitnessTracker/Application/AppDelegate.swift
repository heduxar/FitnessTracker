//
//  AppDelegate.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 11.06.2020.
//  Copyright © 2020 Юрий Султанов. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyBb9jCyZcaFUp4XLpO0IqBdsh0AnOH8kSA")
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert,
                                            .sound,
                                            .badge]) { granted, error in
                                                if granted {
                                                    print("Notification granted")
                                                } else {
                                                    print("Notification denied")
                                                }
        }
        return true
    }

    // MARK: - UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

