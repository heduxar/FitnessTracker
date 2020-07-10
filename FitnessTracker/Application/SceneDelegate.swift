//
//  SceneDelegate.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 11.06.2020.
//  Copyright © 2020 Юрий Султанов. All rights reserved.
//

import UIKit
import Security

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var visualEffectView = UIVisualEffectView()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let navController = UINavigationController()
        
        if UserDefaults.standard.isLogined {
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

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        visualEffectView.removeFromSuperview()
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
        print("BackgroundMode")
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

