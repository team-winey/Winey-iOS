//
//  LoginService.swift
//  Winey
//
//  Created by 김응관 on 2023/08/04.
//

import Foundation

import Moya

final class LoginService {
    
    let loginProvider = CustomMoyaProvider<LoginAPI>()
    
    init() {}
    
    private(set) var loginData: BaseResponse<LoginResponse>?
    
    // 1. 애플 로그인
    
    func loginWithApple(socialType: String, token: String,
                        completion: @escaping (BaseResponse<LoginResponse>?) -> Void) {
        loginProvider.request(.appleLogin(socialType: socialType, token: token)) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.loginData = try response.map(BaseResponse<LoginResponse>.self)
                    completion(loginData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
}
