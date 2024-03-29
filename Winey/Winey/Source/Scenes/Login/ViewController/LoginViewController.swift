//
//  LoginViewController.swift
//  Winey
//
//  Created by 김응관 on 2023/08/02.
//

import AuthenticationServices
import Combine
import UIKit

import DesignSystem
import SnapKit
import SafariServices

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    private let loginView = LoginView()
    private let loginService = LoginService()
    
    private var userId: Int?
    private var refreshToken: String?
    private var isRegistered: Bool = false
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    
    private lazy var registerPublisher = PassthroughSubject<Bool, Never>()
    private lazy var bag = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
    private let character: UIImageView = {
        let img = UIImageView()
        img.image = .Login.character?.resizeWithWidth(width: UIScreen.main.bounds.width - 110)
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private let appleButton: LoginButton = {
        let button = LoginButton(type: .apple)
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    private let kakaoButton: LoginButton = {
        let button = LoginButton(type: .kakao)
        button.contentMode = .scaleAspectFit
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
    
    private let privacyPolicyLabel = UILabel()
    private let privacyPolicyBoldLabel = UILabel()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setAddTarget()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let logEvent = LogEventImpl(category: .view_signup, parameters: ["screen_name": "sign_up"])
        AmplitudeManager.logEvent(event: logEvent)
    }
    
    private func setUI() {
        view.backgroundColor = .winey_gray0
        
        privacyPolicyLabel.textAlignment = .center
        privacyPolicyBoldLabel.textAlignment = .center
        privacyPolicyLabel.setText(Const.policyString, attributes: Const.policyAttributes)
        privacyPolicyBoldLabel.setText(Const.policyBoldString, attributes: Const.policyBoldAttributes)
    }
    
    private func setLayout() {
        view.addSubviews(loginView, character, kakaoButton, appleButton, activityIndicator)
        view.addSubviews(privacyPolicyLabel, privacyPolicyBoldLabel)
        
        loginView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(0.085 * UIScreen.main.bounds.height)
            $0.centerX.equalToSuperview()
        }
        
        character.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(0.29 * UIScreen.main.bounds.height)
            $0.leading.equalToSuperview().inset(40)
            $0.trailing.equalToSuperview().inset(70)
        }
        
        kakaoButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(54)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset((0.075 * UIScreen.main.bounds.height) + 64)
        }
        
        appleButton.snp.makeConstraints {
            $0.top.equalTo(kakaoButton.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(kakaoButton.snp.horizontalEdges)
            $0.height.equalTo(54)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(0.075 * UIScreen.main.bounds.height)
        }
        
        privacyPolicyLabel.snp.makeConstraints {
            $0.top.equalTo(appleButton.snp.bottom).offset(Const.policyTop.adjustedH)
            $0.centerX.equalToSuperview()
        }
        
        privacyPolicyBoldLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(privacyPolicyLabel.snp.bottom).offset(2)
        }
        
        let touchableView = UIView()
        touchableView.backgroundColor = .clear
        touchableView.isUserInteractionEnabled = true
        self.privacyPolicyBoldLabel.isUserInteractionEnabled = true
        self.privacyPolicyBoldLabel.addSubview(touchableView)
        
        touchableView.snp.makeConstraints {
            $0.top.equalTo(privacyPolicyBoldLabel.snp.top).offset(-8)
            $0.leading.trailing.equalToSuperview().inset(-5)
            $0.bottom.equalTo(privacyPolicyBoldLabel).offset(8)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapWineyRule))
        touchableView.addGestureRecognizer(tapGesture)
    }
    
    private func setAddTarget() {
        appleButton.addTarget(self, action: #selector(appleLogin), for: .touchUpInside)
        kakaoButton.addTarget(self, action: #selector(kakaoLogin), for: .touchUpInside)
    }
    
    private func bind() {
        registerPublisher
            .sink { [weak self] flag in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    if UserDefaults.standard.bool(forKey: "Signed") {
                        let vc = flag == true ? TabBarController() : AnimationOnboardingViewController()
                        self?.switchRootViewController(rootViewController: vc, animated: true)
                    }
                }
            }
            .store(in: &bag)
    }
    
    @objc private func tapWineyRule() {
        let url = URL(string: "https://empty-weaver-a9f.notion.site/iney-9dbfe130c7df4fb9a0903481c3e377e6?pvs=4")!
        let safariViewController = SFSafariViewController(url: url)
        self.present(safariViewController, animated: true)
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    @objc
    private func kakaoLogin() {
        let logEvent = LogEventImpl(
            category: .click_button,
            parameters: [
                "button_name": ["kakao_signup_button", "onboarding_button"],
                "page_number": 1
            ]
        )
        AmplitudeManager.logEvent(event: logEvent)
        loginService.kakaoLogin(completion:{token in
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.kakaoButton.isHidden = true
                self.appleButton.isHidden = true
                self.loginView.isHidden = true
                self.character.isHidden = true
                self.privacyPolicyLabel.isHidden = true
                self.privacyPolicyBoldLabel.isHidden = true
                // 2. 이 VC로 왔다는 것은 로그인이 필요한 상황 -> identityToken을 통한 Token들 재발급이 필요함
                DispatchQueue.global(qos: .background).async {
                    
                    // 3. 다른 쓰레드에서는 로그인 실행
                    print("identityToken으로 로그인 실행")
                    let req = LoginRequest(socialType: "KAKAO")
                    self.loginWithKakao(request: req,
                                        token: token)
                }
            }
        }
        )
    }
    
    @objc
    private func appleLogin() {
        let logEvent = LogEventImpl(
            category: .click_button,
            parameters: [
                "button_name": ["apple_signup_button", "onboarding_button"],
                "page_number": 1
            ]
        )
        AmplitudeManager.logEvent(event: logEvent)
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            if let authorizationCode = appleIDCredential.authorizationCode,
               let identityToken = appleIDCredential.identityToken,
               let authCodeString = String(data: authorizationCode, encoding: .utf8),
               let identifyTokenString = String(data: identityToken, encoding: .utf8) {
                
                print("authCodeString: \(authCodeString)")
                print("identifyTokenString: \(identifyTokenString)")
                
                // identityToken은 10분 후에 만료
                
                // 로그아웃 상태 -> accessToken이 키체인에 없음
                // 로그인 상태 -> accessToken이 키체인에 있음
                // 재로그인을 한다면, identityToken을 사용하여 accessToken/refreshToken을 재발급 받아야함
                
                // 1. 화면 상에서는 activityIndicator만 보이도록 뷰를 설정
                DispatchQueue.main.async {
                    self.activityIndicator.startAnimating()
                    self.kakaoButton.isHidden = true
                    self.appleButton.isHidden = true
                    self.loginView.isHidden = true
                    self.character.isHidden = true
                    self.privacyPolicyLabel.isHidden = true
                    self.privacyPolicyBoldLabel.isHidden = true
                    // 2. 이 VC로 왔다는 것은 로그인이 필요한 상황 -> identityToken을 통한 Token들 재발급이 필요함
                    DispatchQueue.global(qos: .background).async {
                        
                        // 3. 다른 쓰레드에서는 로그인 실행
                        print("identityToken으로 로그인 실행")
                        let req = LoginRequest(socialType: "APPLE")
                        self.loginWithApple(request: req,
                                            token: identifyTokenString)
                    }
                }
            }
            
        case let passwordCredential as ASPasswordCredential:
            
            // Sign in using an existing iCloud Keychain credential.
            _ = passwordCredential.user
            _ = passwordCredential.password
            
        default:
            break
        }
    }
}

func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    print("Authorization Failed")
}

// MARK: - Network

extension LoginViewController {
    private func loginWithApple(request: LoginRequest, token: String) {
        loginService.loginWithApple(request: request, token: token) { response in
            guard let response = response else { return }
            switch response.code {
            case 200..<300:
                UserDefaults.standard.set(true, forKey: "Signed")
                UserDefaults.standard.set(true, forKey: "notRegistered")
                UserDefaults.standard.set("APPLE", forKey: "loginType")
                
                print(UserDefaults.standard.bool(forKey: "Signed"))
                print("로그인 성공 -> accessToken/refreshToken을 키체인에 저장")
                
                KeychainManager.shared.delete("refreshToken")
                KeychainManager.shared.delete("accessToken")

                print(response.message)
                print("access \(response.data.accessToken)")
                print("refresh \(response.data.refreshToken)")
                
                KeychainManager.shared.create(response.data.refreshToken, "refreshToken")
                KeychainManager.shared.create(response.data.accessToken, "accessToken")
                
                self.registerPublisher.send(response.data.isRegistered)
            default:
                print(500)
            }
        }
    }
    private func loginWithKakao(request: LoginRequest, token: String) {
        loginService.loginWithKakao(request: request, token: token) { response in
            guard let response = response else { return }
            switch response.code {
            case 200..<300:
                UserDefaults.standard.set(true, forKey: "Signed")
                UserDefaults.standard.set(true, forKey: "notRegistered")
                UserDefaults.standard.set("KAKAO", forKey: "loginType")

                print(UserDefaults.standard.bool(forKey: "Signed"))
                print("로그인 성공 -> accessToken/refreshToken을 키체인에 저장")
                
                KeychainManager.shared.delete("refreshToken")
                KeychainManager.shared.delete("accessToken")
                
                print(response.message)
                print("access \(response.data.accessToken)")
                print("refresh \(response.data.refreshToken)")
                
                KeychainManager.shared.create(response.data.refreshToken, "refreshToken")
                KeychainManager.shared.create(response.data.accessToken, "accessToken")
                
                self.registerPublisher.send(response.data.isRegistered)
            default:
                print(500)
            }
        }
    }
}

extension LoginViewController {
    enum Const {
        static let policyString = "가입 시, Winey의 다음 사항에 동의하는 것으로 간주합니다."
        static let policyBoldString = "서비스 이용약관 및 개인정보 정책"
        
        static let policyAttributes = Typography.Attributes(
            style: .detail3,
            weight: .medium,
            textColor: .winey_gray400
        )
        
        static let policyBoldAttributes = Typography.Attributes(
            style: .detail3,
            weight: .bold,
            textColor: .winey_gray600
        )
        
        static let policyTop: CGFloat = 20
    }
}
