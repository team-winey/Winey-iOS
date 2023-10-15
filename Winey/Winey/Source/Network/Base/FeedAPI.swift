//
//  FeedRouter.swift
//  Winey
//
//  Created by 김인영 on 2023/07/17.
//

import Foundation

import Moya

enum FeedAPI {
    case getTotalFeed(page: Int)
    case getMyFeed(page: Int)
    case deleteMyFeed(idx: Int)
    case detail(id: Int)
}

extension FeedAPI: WineyAPI, AccessTokenAuthorizable {
    var path: String {
        switch self {
        case .getTotalFeed:
            return URLConstant.feed
        case .getMyFeed:
            return URLConstant.myfeed
        case .deleteMyFeed(let idx):
            return "\(URLConstant.feed)/\(idx)"
        case .detail(let feedId):
            return "/feed/\(feedId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyFeed, .getTotalFeed, .detail:
            return .get
        case .deleteMyFeed:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getTotalFeed(let page), .getMyFeed(page: let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
        case .deleteMyFeed, .detail:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getMyFeed, .getTotalFeed, .deleteMyFeed, .detail:
            return ["Content-Type": "application/json",
                    "accessToken": KeychainManager.shared.read("accessToken")!]
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
