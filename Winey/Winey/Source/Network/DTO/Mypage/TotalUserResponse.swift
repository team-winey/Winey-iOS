//
//  TotalUserResponse.swift
//  Winey
//
//  Created by 고영민 on 2023/07/19.
//

import Foundation

struct TotalUserResponse: Codable {
    let userResponseUserDto: UserResponseUserDto
    let userResponseGoalDto: UserResponseGoalDto
}

struct UserResponseGoalDto: Codable {
    let duringGoalAmount, duringGoalCount, targetMoney, targetDay: Int
    let isOver: Bool
    let dday: Int
    let isAttained: Bool
}

struct UserResponseUserDto: Codable {
    let userID: Int
    let nickname, userLevel: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickname, userLevel
    }
}
