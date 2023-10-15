//
//  GoalAPI.swift
//  Winey
//
//  Created by 김인영 on 2023/07/20.
//

import Foundation

import Moya

enum GoalAPI {
    case postGoal(request: PostGoalRequest)
}

extension GoalAPI: TargetType, AccessTokenAuthorizable {
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
        case .postGoal:
            return URLConstant.goal
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postGoal:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .postGoal(let request):
            return .requestJSONEncodable(request)
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
