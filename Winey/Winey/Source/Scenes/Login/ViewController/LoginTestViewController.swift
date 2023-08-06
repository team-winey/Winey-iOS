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
    }
    
    @objc
    private func appleLogout() {
        var success = false
        
        let userId = UserDefaults.standard.string(forKey: "userId")
        let token = getToken(userId!)
        
        DispatchQueue.global(qos: .utility).async {
            success = self.logoutWithApple(token: token!)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if success == true {
                UserDefaults.standard.set(false, forKey: "Signed")
                
                let vc = LoginViewController()
                self.switchRootViewController(rootViewController: vc, animated: true)
            } else {
                print("로그아웃 실패")
            }
        }
    }
    
    @objc
    private func appleWithdraw() {
        var success = false
        
        let userId = UserDefaults.standard.string(forKey: "userId")
        let token = getToken("refreshToken")
        
        DispatchQueue.global(qos: .utility).async {
            success = self.logoutWithApple(token: token!)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if success == true {
                UserDefaults.standard.set(false, forKey: "Signed")
                
                let vc = LoginViewController()
                self.switchRootViewController(rootViewController: vc, animated: true)
            } else {
                print("로그아웃 실패")
            }
        }
    }
    
    
    private func getToken(_ id: String) -> String? {
        do {
            let token = try KeychainManager(id: id).getToken()
            return token
        } catch {
            return nil
        }
    }
}

extension LoginTestViewController {
    
    private func logoutWithApple(token: String) -> Bool {
        var logoutResult = false
        loginService.logoutWithApple(token: token) { result in
            logoutResult = result
        }
        return logoutResult
    }
    
    private func withdrawApple(token: String) -> Bool {
        var result = false
        loginService.withdrawApple(token: token) { withdrawResult in
            result = withdrawResult
        }
        return result
    }
}