//
//  NicknameResponse.swift
//  Winey
//
//  Created by 김응관 on 2023/08/19.
//

import Foundation

struct NicknameResponse {
    let code: Int
    let message: String
    let data: NSNull
}

struct DuplicateCheckResponse: Codable {
    let code: Int
    let message: String
    let data: CheckResult
}

struct CheckResult: Codable {
    let isDuplicated: Bool
}
