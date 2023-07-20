//
//  NetworkConstant.swift
//  Winey
//
//  Created by 김인영 on 2023/07/17.
//

import Foundation

struct NetworkConstant {
    // userId는 5까지 아무거나 사용 가능
    static let defaultHeader = ["Content-Type": "application/json", "userId": "\(UserSingleton.getId())"]
    static let postfeedHeader = ["Content-Type": "multipart/form-data", "userId": "\(UserSingleton.getId())"]
}
