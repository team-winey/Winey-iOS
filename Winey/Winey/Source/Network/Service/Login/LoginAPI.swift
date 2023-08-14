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
    case reissueToken(token: String)
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
        case .reissueToken:
            return URLConstant.token
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .appleLogin, .appleLogout, .reissueToken:
            return .post
        case .appleWithdraw:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .appleLogin(let request, _):
            return .requestJSONEncodable(request)
        case .appleLogout, .appleWithdraw, .reissueToken:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .appleLogin(_, let token):
            return ["Content-Type": "application/json",
                                              "Authorization": token]
        case .appleLogout(let token), .appleWithdraw(let token):
            return ["Content-Type": "application/json",
                                              "accessToken": token]
        case .reissueToken(let token):
            return ["Content-Type": "application/json",
                                              "refreshToken": token]
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
