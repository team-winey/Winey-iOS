//
//  NicknameAPI.swift
//  Winey
//
//  Created by 김응관 on 2023/08/19.
//

import Foundation

import Moya

enum NicknameAPI {
    case changeNickname(nickname: String)
    case checkNicknameDuplicate(nickname: String)
}

extension NicknameAPI: TargetType {
    
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
           case .changeNickname:
               return URLConstant.changeNickname
           case .checkNicknameDuplicate:
               return URLConstant.checkNicknameDuplicate
           }
       }

       var method: Moya.Method {
           switch self {
           case .changeNickname:
               return .patch
           case .checkNicknameDuplicate:
               return .get
           }
       }

       var task: Moya.Task {
           switch self {
           case .changeNickname(let nickname):
               return .requestJSONEncodable(nickname)
           case .checkNicknameDuplicate(let nickname):
               return .requestParameters(parameters: ["nickname": nickname], encoding: URLEncoding.queryString)
           }
       }

       var headers: [String : String]? {
           switch self {
           case .changeNickname:
               return NetworkConstant.defaultHeader
           case .checkNicknameDuplicate:
               return NetworkConstant.nicknameDuplicateCheckHeader
           }
       }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
