//
//  RecommendAPI.swift
//  Winey
//
//  Created by 김인영 on 2023/07/20.
//

import Foundation

import Moya

enum RecommendAPI {
    case getTotalRecommend(page: Int)
}

extension RecommendAPI: TargetType, AccessTokenAuthorizable {
    
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
        case .getTotalRecommend:
            return URLConstant.recommend
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTotalRecommend:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getTotalRecommend(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getTotalRecommend:
            return NetworkConstant.defaultHeader
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
