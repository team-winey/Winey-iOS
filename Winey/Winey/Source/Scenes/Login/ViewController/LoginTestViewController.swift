//
//  LoginTestViewController.swift
//  Winey
//
//  Created by 김응관 on 2023/08/05.
//

import UIKit

import SnapKit

class LoginTestViewController: UIViewController {
    
    private let loginService = LoginService()
    
    private let logOutButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("로그아웃", for: .normal)
        return btn
    }()
    
    private let withDrawButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("회원탈퇴", for: .normal)
        return btn
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicator.center = self.view.center
        activityIndicator.color = .winey_gray600
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium

        activityIndicator.stopAnimating()
        return activityIndicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        view.addSubviews(logOutButton, withDrawButton)
        
        logOutButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(140)
            $0.height.equalTo(50)
        }
        
        withDrawButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logOutButton.snp.bottom).offset(50)
            $0.width.equalTo(140)
            $0.height.equalTo(50)
        }
        
        logOutButton.addTarget(self, action: #selector(appleLogout), for: .touchUpInside)
        withDrawButton.addTarget(self, action: #selector(appleWithdraw), for: .touchUpInside)
    }
    
    @objc
    private func appleLogout() {
        let token = KeychainManager.shared.read("accessToken")!
        DispatchQueue.global(qos: .utility).async {
            self.logoutWithApple(token: token)
        }
    }
    
    @objc
    private func appleWithdraw() {
        let token = KeychainManager.shared.read("accessToken")!
        DispatchQueue.global(qos: .utility).async {
            self.withdrawApple(token: token)
        }
    }
}

extension LoginTestViewController {
    
    private func logoutWithApple(token: String) {
        loginService.logoutWithApple(token: token) { result in
            if result {
                KeychainManager.shared.delete("accessToken")
                KeychainManager.shared.delete("refreshToken")
                
                UserDefaults.standard.set(false, forKey: "Signed")
                
                DispatchQueue.main.async {
                    let vc = LoginViewController()
                    self.switchRootViewController(rootViewController: vc, animated: true)
                }
            } else {
                print("로그아웃 실패")
            }
        }
    }
    
    private func withdrawApple(token: String) {
        loginService.withdrawApple(token: token) { result in
            if result {
                KeychainManager.shared.delete("accessToken")
                KeychainManager.shared.delete("refreshToken")
                
                // self.deleteToken("identityToken")
                UserDefaults.standard.set(false, forKey: "Signed")
                
                DispatchQueue.main.async {
                    let vc = LoginViewController()
                    self.switchRootViewController(rootViewController: vc, animated: true)
                }
            } else {
                print("회원탈퇴 실패")
            }
        }
    }
}
