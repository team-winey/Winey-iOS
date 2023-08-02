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
        
        if UserSingleton.getId() == -1 {
            UserSingleton.saveId(1)
        }
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        let splashViewController = LoginViewController()
        window.rootViewController = splashViewController
        window.makeKeyAndVisible()
    }
}
