//
//  FeedLikeAPI.swift
//  Winey
//
//  Created by 김인영 on 2023/07/19.
//

import Foundation

import Moya

enum FeedLikeAPI {
    case postLike(feedId: Int, feedLike: Bool)
}

extension FeedLikeAPI: TargetType, AccessTokenAuthorizable {
    
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
        case .postLike(let feedId, _):
            return URLConstant.feedLike + "/\(feedId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postLike:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .postLike(_, let feedLike):
            return .requestJSONEncodable(feedLike)
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
