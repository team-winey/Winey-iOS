//
//  SplashViewController.swift
//  Winey
//
//  Created by Woody Lee on 2023/07/21.
//

import UIKit

import DesignSystem

final class SplashViewController: UIViewController {
    
    private let animationView = AnimationView.splashView
    private var window: UIWindow? {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return scene.windows.first
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .winey_gray900
        view.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.play()
        
        print(UserDefaults.standard.bool(forKey: "Signed"))
        
        Timer.scheduledTimer(
            timeInterval: 2.5,
            target: self,
            selector: #selector(didFinishSplash),
            userInfo: nil,
            repeats: false
        )
    }
    
    @objc private func didFinishSplash() {
        
        var rootViewController = UIViewController()
        let signed = UserDefaults.standard.bool(forKey: "Signed")
        
        let refreshToken = KeychainManager.shared.read("refreshToken")
        let notFirstLaunch = UserDefaults.standard.bool(forKey: "notFirstLaunch")
        let notRegistered = UserDefaults.standard.bool(forKey: "notRegistered")
        
        if notFirstLaunch && notRegistered {
            // 로그인 여부에 따라 다른 VC로 이동
            if signed {
                print("로그인 되어 있음")
                // 로그인이 되어 있다면 로그인 후의 화면으로 진입
                // 이와 동시에 refreshToken을 활용한 accessToken/refreshToken 업데이트!
                print("리프레쉬(나한텐 액세스) 토큰 유효")
                print(refreshToken! as String)
                DispatchQueue.main.async {
                    LoginService.shared.reissueApple(token: refreshToken! as String) { result in
                        switch result {
                            // 토큰 재발급 성공 -> 로그인 후의 화면으로
                        case true:
                            print("토큰 재발급 성공, 로그인이 되어 있으므로 메인 뷰로 이동")
                            // rootViewController = LoginTestViewController()
                            rootViewController = TabBarController()
                            // 토큰 재발급 실패 -> 로그인 화면으로 이동
                        case false:
                            print("토큰 재발급 실패, 로그인을 다시 해주세요")
                            rootViewController = LoginViewController()
                        }
                        self.window?.rootViewController = rootViewController
                    }
                }
            } else {
                print("로그인이 되어 있지 않음")
                rootViewController = LoginViewController()
            }
        } else {
            print("OnBoarding 뷰로 이동")
            rootViewController = OnboardingViewController()
        }
            
        
        UIView.transition(
            with: self.window!,
            duration: 0.2,
            options: .transitionCrossDissolve,
            animations: {
                self.window?.rootViewController = rootViewController
            },
            completion: nil
        )
    }
}
