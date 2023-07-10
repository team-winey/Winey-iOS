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
<<<<<<< HEAD
        let tabBarController = UploadViewController()
=======
        let tabBarController =  UploadViewController()
>>>>>>> 0bf8176 ([Add] #8 - ViewController에선언된 함수들 내용 작성 및 NavigationBar 객체 생성)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
