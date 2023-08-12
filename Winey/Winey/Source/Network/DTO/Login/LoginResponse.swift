//
//  LoginResponse.swift
//  Winey
//
//  Created by 김응관 on 2023/08/04.
//

import Foundation

struct LoginResponse: Decodable {
    let code: Int
    let message: String
    let data: UserData
}

struct UserData: Decodable {
    let userID: Int
    let refreshToken: String
    let accessToken: String
    let isRegistered: Bool
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case refreshToken, accessToken, isRegistered
    }
}

struct LogoutResponse: Decodable {
    let code: Int
    let message: String
}
