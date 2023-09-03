//
//  SceneDelegate.swift
//  Winey
//
//  Created by 김인영 on 2023/07/01.
//

import UIKit
import KakaoSDKAuth

import DesignSystem

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
        window.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
    // 앱을 background에서 foreground로 불러올 경우
    func sceneWillEnterForeground(_ scene: UIScene) {
        guard let refreshToken = KeychainManager.shared.read("refreshToken") else { return }
        print("background에서 foreground로 진입")
        
        print("리프레쉬 토큰을 통한 액세스 토큰 재발급")
        LoginService.shared.reissueApple(token: refreshToken) { result in
            switch result {
            case true:
                print("토큰 재발급 성공!")
            case false:
                print("refreshToken 만료")
                print("토큰 재발급 실패 -> LoginView로 변환")
                guard let windowScene = (scene as? UIWindowScene) else { return }
                let window = UIWindow(windowScene: windowScene)
                self.window = window
                self.setAlert(window)
            }
        }
        
        NotificationCenter.default.post(name: .whenEnterForeground, object: nil)
    }
    
    func setAlert(_ window: UIWindow) {
        let alert = MIPopupViewController(
            content: .init(
                title: "세션이 만료되었습니다",
                subtitle: "확인 버튼을 눌러서 다시 로그인을 진행해주세요"
            )
        )
        alert.addButton(title: "확인", type: .yellow) {
            window.rootViewController = LoginViewController()
            window.makeKeyAndVisible()
        }
        window.rootViewController = alert
        window.makeKeyAndVisible()
        window.backgroundColor = .winey_gray0
    }
}
