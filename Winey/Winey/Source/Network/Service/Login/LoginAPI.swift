//
//  LoginAPI.swift
//  Winey
//
//  Created by 김응관 on 2023/08/04.
//

import Foundation

import Moya

enum LoginAPI {
    case appleLogin(request: LoginRequest, token: String)
    case appleLogout(token: String)
    case appleWithdraw(token: String)
}


extension LoginAPI: TargetType, AccessTokenAuthorizable {
    var authorizationType: Moya.AuthorizationType? {
        switch self {
        default:
            return nil
        }
    }
    
    var baseURL: URL {
        return URL(string: URLConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .appleLogin:
            return URLConstant.signIn
        case .appleLogout:
            return URLConstant.signOut
        case .appleWithdraw:
            return URLConstant.withdraw
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .appleLogin, .appleLogout:
            return .post
        case .appleWithdraw:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .appleLogin(let request, _):
            return .requestJSONEncodable(request)
        case .appleLogout, .appleWithdraw:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .appleLogin(_, let token), .appleLogout(let token), .appleWithdraw(let token):
            return ["Content-Type": "application/json",
                                              "Authorization": token]
        }
    }
}
