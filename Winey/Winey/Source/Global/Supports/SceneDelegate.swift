//
//  SceneDelegate.swift
//  Winey
//
//  Created by 김인영 on 2023/07/01.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        let tabBarController = SaveGoalViewController()
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
