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
    case postFeed(feed: UploadModel)
}

extension API: TargetType {
    var baseURL: URL {
        return URL(string: URLConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getTotalFeed, .postFeed:
            return URLConstant.feed
        case .getMyFeed:
            return URLConstant.myfeed
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyFeed, .getTotalFeed:
            return .get
        case .postFeed:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getTotalFeed(let page), .getMyFeed(page: let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
        case .postFeed(let feed):
            return .requestJSONEncodable(feed)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getMyFeed, .getTotalFeed:
            return NetworkConstant.getfeedHeader
        case .postFeed:
            return NetworkConstant.postfeedHeader
        }
    }
}
