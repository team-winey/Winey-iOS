//
//  WineyAPI.swift
//  Winey
//
//  Created by Woody Lee on 2023/08/10.
//

import Foundation

import Moya

protocol WineyAPI: TargetType {}

extension WineyAPI {
    var baseURL: URL {
        return URL(string: URLConstant.baseURL)!
    }
    
    var headers: [String : String]? {
        return NetworkConstant.defaultHeader
    }
}
