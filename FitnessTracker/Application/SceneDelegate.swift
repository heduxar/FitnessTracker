//
//  SceneDelegate.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 11.06.2020.
//  Copyright © 2020 Юрий Султанов. All rights reserved.
//

import UIKit
import Security
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var visualEffectView = UIVisualEffectView()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let navController = UINavigationController()
        
        print(try! RealmProvider.get(RealmUserModel.self).count > 0)
        
        if try! RealmProvider.get(RealmUserModel.self).count > 0 &&
            UserDefaults.standard.isLoginedUserID != 0 {
            guard let windowScene = (scene as? UIWindowScene),
                let vc = MainBuilder().build() as? MainViewController
                else { fatalError("Couldn't cast to MainViewController!") }
            window = UIWindow(frame: windowScene.coordinateSpace.bounds)
            window?.windowScene = windowScene
            window?.rootViewController = navController
            navController.pushViewController(vc, animated: true)
        } else {
            guard let windowScene = (scene as? UIWindowScene),
                let vc = LoginBuilder().build() as? LoginViewController
                else { fatalError("Couldn't cast to LoginViewController!") }
            window = UIWindow(frame: windowScene.coordinateSpace.bounds)
            window?.windowScene = windowScene
            window?.rootViewController = navController
            navController.pushViewController(vc, animated: true)
        }
        
        window?.makeKeyAndVisible()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        visualEffectView.removeFromSuperview()
        if UIApplication.shared.applicationIconBadgeNumber > 0 {
            UIApplication.shared.applicationIconBadgeNumber -= 1
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        guard UserDefaults.standard.isSecuredScreen,
            let window = window else { return }
        if !visualEffectView.isDescendant(of: window) {
            let blurEffect = UIBlurEffect(style: .light)
            visualEffectView = UIVisualEffectView(effect: blurEffect)
            visualEffectView.frame = window.bounds
            window.addSubview(visualEffectView)
        }
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        visualEffectView.removeFromSuperview()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        guard !UserDefaults.standard.isTrackRoute else { return }
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            guard let content = self?.makeNotificationContent(),
                let trigger = self?.makeIntervalNotificatioTrigger(),
                settings.authorizationStatus == .authorized else {
                    debugPrint("Notification denied")
                    return
            }
            self?.sendNotificatioRequest(content: content,
                                         trigger: trigger)
        }
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    // MARK: - Private methods
    private func makeNotificationContent() -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "FitnessTracker still active"
        content.body = "🔋 Close app for save your battery 🔋"
        content.sound = .defaultCritical
        DispatchQueue.main.async {
           content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        }
        return content
    }
    
    private func makeIntervalNotificatioTrigger() -> UNNotificationTrigger {
        UNTimeIntervalNotificationTrigger(
            timeInterval: 60*30,
            repeats: false
        )
    }
    
    private func makeDateNotificationTrigger() -> UNNotificationTrigger {
        var date = DateComponents()
        date.hour = 19
        date.minute = 0
        return UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
    }
    
    private func sendNotificatioRequest(content: UNNotificationContent,
                                        trigger: UNNotificationTrigger) {
        let request = UNNotificationRequest(
            identifier: "\(Bundle.main.bundleIdentifier ?? "")_notify",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

