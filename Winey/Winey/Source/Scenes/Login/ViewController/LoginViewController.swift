//
//  LoginViewController.swift
//  Winey
//
//  Created by 김응관 on 2023/08/02.
//

import AuthenticationServices
import UIKit

import DesignSystem
import SnapKit

class LoginViewController: UIViewController {

    // MARK: - Properties
    private let loginView = LoginView()
    private let loginService = LoginService()
    private var userId: Int = 0
    private var refreshToken: String = ""
    private var accessToken: String = ""
    private var isRegistered: Bool = false
    private lazy var safeArea = self.view.safeAreaLayoutGuide

    // MARK: - UI Components
    
    private let appleButton: LoginButton = {
        let button = LoginButton(type: .apple)
        return button
    }()
    
    private let kakaoButton: LoginButton = {
        let button = LoginButton(type: .kakao)
        return button
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
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setAddTarget()
    }
    
    private func setUI() {
        view.backgroundColor = .winey_gray0
    }
    
    private func setLayout() {
        view.addSubviews(loginView, kakaoButton, appleButton, activityIndicator)
        
        loginView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(72)
            $0.leading.equalToSuperview().inset(40)
            $0.trailing.equalToSuperview().inset(70)
        }
        
        kakaoButton.snp.makeConstraints {
            $0.top.equalTo(loginView.snp.bottom).offset(48)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(54)
        }
        
        appleButton.snp.makeConstraints {
            $0.top.equalTo(kakaoButton.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(kakaoButton.snp.horizontalEdges)
            $0.height.equalTo(54)
        }
    }
    
    private func setAddTarget() {
        appleButton.addTarget(self, action: #selector(appleLogin), for: .touchUpInside)
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    @objc
    private func appleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let requests = [request, ASAuthorizationPasswordProvider().createRequest()]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            
            if  let authorizationCode = appleIDCredential.authorizationCode,
                let identityToken = appleIDCredential.identityToken,
                let authCodeString = String(data: authorizationCode, encoding: .utf8),
                let identifyTokenString = String(data: identityToken, encoding: .utf8) {
                print("authCodeString: \(authCodeString)")
                print("identifyTokenString: \(identifyTokenString)")
                
                saveToken(identityToken, String(describing: userIdentifier))
                UserDefaults.standard.set(true, forKey: "Signed")
                
                DispatchQueue.global(qos: .utility).async {
                    self.loginWithApple(socialType: "APPLE", token: identifyTokenString)
                }
                
                DispatchQueue.main.async {
                    self.activityIndicator.startAnimating()
                    self.kakaoButton.isHidden = true
                    self.appleButton.isHidden = true
                    self.loginView.isHidden = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let vc = TabBarController()
                self.switchRootViewController(rootViewController: vc, animated: true)
            }
        
        case let passwordCredential as ASPasswordCredential:

            // Sign in using an existing iCloud Keychain credential.
            _ = passwordCredential.user
            _ = passwordCredential.password
            
            UserDefaults.standard.set(true, forKey: "Signed")
            print(UserDefaults.standard.bool(forKey: "Signed"))
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Authorization Failed")
    }
    
    private func saveToken(_ token: Data, _ id: String) {
        do {
            try KeychainManager(id: id).saveToken(token)
        } catch {
            print("token saving error")
        }
    }
}

extension LoginViewController {
    private func loginWithApple(socialType: String, token: String) {
        loginService.loginWithApple(socialType: socialType, token: token) {
            [weak self] response in
            guard let response = response,
                    let data = response.data else { return }
            guard let self = self else { return }
            self.userId = data.data.userId
            self.refreshToken = data.data.refreshToken
            self.accessToken = data.data.accessToken
            self.isRegistered = data.data.isRegistered
        }
    }
}

