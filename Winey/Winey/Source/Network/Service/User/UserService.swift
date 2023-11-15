//
//  UserService.swift
//  Winey
//
//  Created by 김인영 on 2023/07/17.
//

import Foundation

import Moya

final class UserService {
    
    let userProvider = CustomMoyaProvider<UserAPI>()
    
    init() { }
    
    private(set) var totalUserData:
    BaseResponse<TotalUserResponse>?
    
    func getTotalUser(completion: @escaping (BaseResponse<TotalUserResponse>?) -> Void) {
        userProvider.request(.getTotalUser) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.totalUserData = try response.map(BaseResponse<TotalUserResponse>.self)
                    completion(totalUserData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                LoginService.shared.reissueApple(token: KeychainManager.shared.read("refreshToken") ?? "") { _ in }
                print(err)
            }
        }
    }
}
