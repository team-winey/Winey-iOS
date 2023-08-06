//
//  LoginService.swift
//  Winey
//
//  Created by 김응관 on 2023/08/04.
//

import Foundation

import Moya

final class LoginService {
    
    let authProvider = CustomMoyaProvider<LoginAPI>()
    
    init() {}
    
    private(set) var loginResponse: LoginResponse?
    private(set) var logoutData: BaseResponse<LogoutResponse>?
    
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
                    } catch let error {
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
                do {
                    self.logoutData = try response.map(BaseResponse<LogoutResponse>.self)
                    
                    guard let data = logoutData else { return }
                    
                    switch data.code {
                    case 200..<300:
                        print(data.message!)
                        completion(true)
                    default:
                        print(data.message!)
                        completion(false)
                    }
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func withdrawApple(token: String, _ completion: @escaping ((Bool) -> Void)) {
        authProvider.request(.appleWithdraw(token: token)) { result in
            switch result {
            case .success:
                completion(true)
            case .failure(let err):
                print(err.localizedDescription)
                completion(false)
            }
        }
    }
    
}
