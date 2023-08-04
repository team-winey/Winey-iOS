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
        
        if signed {
            rootViewController = TabBarController()
        } else {
            rootViewController = LoginViewController()
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
