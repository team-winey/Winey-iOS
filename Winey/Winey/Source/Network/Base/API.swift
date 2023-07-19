//
//  FeedRouter.swift
//  Winey
//
//  Created by 김인영 on 2023/07/17.
//

import Foundation

import Moya

enum API {
    case getTotalFeed(page: Int)
    case getMyFeed(page: Int)
}

extension API: TargetType {
    var baseURL: URL {
        return URL(string: URLConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getTotalFeed:
            return URLConstant.feed
        case .getMyFeed:
            return URLConstant.myfeed
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self {
        case .getTotalFeed(let page), .getMyFeed(page: let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return NetworkConstant.defaultHeader
    }
}
