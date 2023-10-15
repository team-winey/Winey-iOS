//
//  CommentAPI.swift
//  Winey
//
//  Created by Woody Lee on 2023/08/10.
//

import Foundation

import Moya

enum CommentAPI {
    case create(request: CreateCommentRequest)
    case delete(commentId: Int)
}

extension CommentAPI: WineyAPI {
    var path: String {
        switch self {
        case .create(let request):
            return "/comment/\(request.feedId)"
        case .delete(let commentId):
            return "/comment/\(commentId)"
        }
    }
    var method: Moya.Method {
        switch self {
        case .create:
            return .post
        case .delete:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .create(let request):
            let parameters: [String: Any] = ["content": request.content]
            return .requestParameters(
                parameters: parameters,
                encoding: JSONEncoding.default
            )
            
        case .delete:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json",
                "accessToken": KeychainManager.shared.read("accessToken")!]
    }
}
