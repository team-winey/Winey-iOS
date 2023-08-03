//
//  LoginResponse.swift
//  Winey
//
//  Created by 김응관 on 2023/08/04.
//

import Foundation

struct LoginResponse {
    let code: Int
    let message: String
    let data: UserData
}

struct UserData {
    let userId: Int
    let refreshToken, accessToken: String
    let isRegistered: Bool
}
