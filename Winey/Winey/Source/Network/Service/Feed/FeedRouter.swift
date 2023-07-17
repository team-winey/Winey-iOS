//
//  FeedRouter.swift
//  Winey
//
//  Created by 김인영 on 2023/07/17.
//

import Foundation

import Moya

enum FeedRouter {
    case getTotalFeed(page: Int)
}

extension FeedRouter: TargetType {
    var baseURL: URL {
        return URL(string: URLConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getTotalFeed:
            return URLConstant.feed
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTotalFeed:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self{
        case .getTotalFeed(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return NetworkConstant.defaultHeader
    }
}
