//
//  LoginAPI.swift
//  Winey
//
//  Created by 김응관 on 2023/08/04.
//

import Foundation

import Moya

enum LoginAPI {
    case appleLogin(provider: String, token: String)
}

extension LoginAPI: TargetType {
    var baseURL: URL {
        return URL(string: URLConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .appleLogin:
            return URLConstant.signIn
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .appleLogin:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .appleLogin(let provider, _):
            return .requestJSONEncodable(provider)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .appleLogin(_, let token):
            return ["Content-Type": "application/json",
                                              "Authorization": token]
        }
    }
}
