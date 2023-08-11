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
    
    func updateToken(_ token: String, _ id: String) {
        do {
            try KeychainManager(id: id).updateToken(token)
            print("update token")
        } catch {
            print("token updating error")
        }
    }
    
    // 토큰 가져오기
    func getToken(_ id: String) -> String? {
        do {
            let token = try KeychainManager(id: id).getToken()
            print("get token")
            return token
        } catch {
            print("get token failed")
            return nil
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
                        self.updateToken(data.refreshToken, "refreshToken")
                        self.updateToken(data.accessToken, "accessToken")
                        print(data.refreshToken)
                        print(data.accessToken)
                        print(reissueResponse?.message)
                        completion(true)
                    } catch {
                        print("Decoding Error")
                    }
                default:
                    // 토큰 재발급의 실패 -> 유효기간이 만료되서 -> 저장되있던 토큰들 삭제
                    self.deleteToken("accessToken")
                    self.deleteToken("refreshToken")
                    print(500)
                    completion(false)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    private func deleteToken(_ id: String) {
        do {
            try KeychainManager(id: id).deleteToken()
        } catch {
            print("token delete failed")
        }
    }
}
