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
    let userId: Int
    let refreshToken, accessToken: String
    let isRegistered: Bool
}
