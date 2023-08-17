//
//  LoginService.swift
//  Winey
//
//  Created by 김응관 on 2023/08/04.
//

import Foundation

import Moya

final class LoginService {
    
    let authProvider = CustomMoyaProvider<LoginAPI>(session: Session(interceptor: SessionInterceptor.shared))
    
    static let shared = LoginService()
    
    init() {}
    
    private(set) var loginResponse: LoginResponse?
    private(set) var logoutResponse: LogoutResponse?
    private(set) var reissueResponse: ReissueResponse?
    
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
    
    func reissueApple(token: String, _ completion: @escaping ((Bool) -> (Void))) {
        authProvider.request(.reissueToken(token: token)) { [self] result in
            print(result)
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200..<300:
                    do {
                        self.reissueResponse = try response.map(ReissueResponse.self)
                        guard let data = self.reissueResponse?.data else { return }
                        _ = try KeychainManager.shared.updateToken(data.refreshToken, "refreshToken")
                        _ = try KeychainManager.shared.updateToken(data.accessToken, "accessToken")
                        print(data.refreshToken)
                        print(data.accessToken)
                        print(reissueResponse?.message as Any)
                        completion(true)
                    } catch(let err) {
                        print(err.localizedDescription)
                    }
                default:
                    // 토큰 재발급의 실패 -> 유효기간이 만료되서 -> 저장되있던 토큰들 삭제
                    do {
                        _ = try KeychainManager.shared.deleteToken("accessToken")
                        _ = try KeychainManager.shared.deleteToken("refreshToken")
                        print(500)
                        completion(false)
                    } catch {
                        print("token delete error")
                    }
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
//    func loginWithKakao() {
//        if (KakaoSDKUser.UserApi.isKakaoTalkLoginAvailable()) {
//
//            //카톡 설치되어있으면 -> 카톡으로 로그인
//            KakaoSDKUser.UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
//                if let error = error {
//                    print(error)
//                } else {
//                    print("카카오 톡으로 로그인 성공")
//
//                    _ = oauthToken
//                    /// 로그인 관련 메소드 추가
//                }
//            }
//        } else {
//
//            // 카톡 없으면 -> 계정으로 로그인
//            KakaoSDKUser.UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
//                if let error = error {
//                    print(error)
//                } else {
//                    print("카카오 계정으로 로그인 성공")
//
//                    _ = oauthToken
//                    // 관련 메소드 추가
//                }
//            }
//        }
//    }
//// MARK: - Send To Server
//    //사용자 정보 불러옴
////    func loadUserInfo(ouathToken: Int?) {
////        UserApi.shared.me { [self] user, error in
////            if let error = error {
////                print(error)
////            } else {
////
////                guard let token = oauthToken?.accessToken, let email = user?.kakaoAccount?.email,
////                      let name = user?.kakaoAccount?.profile?.nickname else{
////                    print("token/email/name is nil")
////                    return
////                }
////
////                self.email = email
////                self.accessToken = token
////                self.name = name
////
////                //서버에 이메일/토큰/이름 보내주기
////            }
////        }
////    }
//    // MARK: - Logout
//    func logout() {
//        UserApi.shared.logout {(error) in
//            if let error = error {
//                print(error)
//            }
//            else {
//                print("logout() success.")
//            }
//        }
//    }
}
