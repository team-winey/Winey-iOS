//
//  UserAPI.swift
//  Winey
//
//  Created by 고영민 on 2023/07/19.
//

import Foundation

import Moya

enum UserAPI {
    case getTotalUser
}
extension UserAPI: TargetType, AccessTokenAuthorizable {
    
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
        case .getTotalUser:
            return URLConstant.user
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTotalUser:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getTotalUser:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json",
                "accessToken": KeychainManager.shared.read("accessToken")!]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
