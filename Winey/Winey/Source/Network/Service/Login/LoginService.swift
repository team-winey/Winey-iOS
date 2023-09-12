//
//  LoginService.swift
//  Winey
//
//  Created by 김응관 on 2023/08/04.
//

import Foundation
import UIKit

import Alamofire
import DesignSystem
import Moya
import KakaoSDKAuth
import KakaoSDKUser


final class LoginService {

    let authProvider = MoyaProvider<LoginAPI>()
    
    static let shared = LoginService()
    
    init() {}
    
    private(set) var loginResponse: LoginResponse?
    private(set) var logoutResponse: LogoutResponse?
    private(set) var reissueResponse: ReissueResponse?
    
    enum WineyError: Error {
        case networkError
        case tokenError
    }
    
    func loginWithKakao(request: LoginRequest, token: String,
                        completion: @escaping ((LoginResponse?) -> Void)) {
        authProvider.request(.kakaoLogin(request: request, token: token)) {
            [self] (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200..<300:
                    do {
                        self.loginResponse = try response.map(LoginResponse.self)
                        completion(loginResponse)
                    } catch {
                        print("response mapping error")
                    }
                default:
                    print(500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    // 1. 애플 로그인
    
    func loginWithApple(request: LoginRequest, token: String,
                        completion: @escaping ((LoginResponse?) -> Void)) {
        authProvider.request(.appleLogin(request: request, token: token)) { [self] (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200..<300:
                    do {
                        self.loginResponse = try response.map(LoginResponse.self)
                        completion(loginResponse)
                    } catch {
                        print("response mapping error")
                    }
                default:
                    print(500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // 2. 애플 로그아웃
    
    func logoutWithApple(token: String, completion: @escaping ((Bool) -> Void)) {
        authProvider.request(.appleLogout(token: token)) { [self] (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200..<300:
                    do {
                        self.logoutResponse = try response.map(LogoutResponse.self)
                        completion(true)
                    } catch let error {
                        print(error.localizedDescription)
                    }
                default:
                    print(500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // 3. 애플 회원탈퇴

    func withdrawApple(token: String, _ completion: @escaping ((Bool) -> Void)) {
        authProvider.request(.appleWithdraw(token: token)) { result in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200..<300:
                    completion(true)
                default:
                    print(500)
                    completion(false)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(false)
            }
        }
    }
    
    // 4. 애플 토큰 재발급
    
    func reissueApple(token: String, _ completion: @escaping (Result<Bool, WineyError>) -> (Void)) {
        authProvider.request(.reissueToken(token: token)) { [self] result in
            print(result)
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200..<300:
                    do {
                        self.reissueResponse = try response.map(ReissueResponse.self)
                        guard let data = self.reissueResponse?.data else { return }
                        
                        KeychainManager.shared.update(data.refreshToken, "refreshToken")
                        KeychainManager.shared.update(data.accessToken, "accessToken")
                        
                        print(data.refreshToken)
                        print(data.accessToken)
                        print(reissueResponse?.message as Any)
                        completion(.success(true))
                    } catch {
                        completion(.failure(.networkError))
                    }
                default:
                    print("network issue")
                }
            case .failure(let err):
                print("리프레쉬 토큰 만료 -> 만료 로직 실행")
                
                // 토큰 삭제
                KeychainManager.shared.delete("accessToken")
                KeychainManager.shared.delete("refreshToken")

                // 로그아웃 처리
                UserDefaults.standard.set(false, forKey: "Signed")

                // 세션 만료 alert 창으로 루트뷰 전환
                setSessionExpireAlert()
                
                print(err)
                
                completion(.failure(.networkError))
            }
        }
    }
    
    func setSessionExpireAlert() {
        let alert = MIPopupViewController(
            content: .init(
                title: "세션이 만료되었습니다",
                subtitle: "확인 버튼을 눌러서 다시 로그인을 진행해주세요"
            )
        )
        alert.addButton(title: "확인", type: .yellow) {
            UIViewController().switchRootViewController(rootViewController: LoginViewController(), animated: true)
        }
        
        let vc = UIViewController()
        vc.view.backgroundColor = .winey_gray50
        vc.switchRootViewController(rootViewController: alert, animated: true)
    }
    
    // MARK: - 로그인
    func kakaoLogin(completion: @escaping ((String) -> Void)) {
        print("KakaoAuthVM - handleKakaoLogin() called()")
        //카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")

                    //do something
                    _ = oauthToken
                    if let oauthToken = oauthToken{
                        completion(oauthToken.accessToken)
                    }
                }
            }
        } else { //카카오톡이 설치가 안되어있으면
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("loginWithKakaoAccount() success.")

                        //do something
                        _ = oauthToken
                        if let oauthToken = oauthToken{
                            completion(oauthToken.accessToken)
                        }
                    }
                }
        }
    }
    // MARK: - 로그아웃
    func kakaoLogOut() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
            }
        }
    }
}
