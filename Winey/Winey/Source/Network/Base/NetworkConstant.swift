//
//  NetworkConstant.swift
//  Winey
//
//  Created by 김인영 on 2023/07/17.
//

import Foundation

struct NetworkConstant {
    static let defaultHeader = ["Content-Type": "application/json",
                                    "accessToken": KeychainManager.shared.read("accessToken")!]
        static let postfeedHeader = ["Content-Type": "multipart/form-data",
                                     "accessToken": KeychainManager.shared.read("accessToken")!]
}
