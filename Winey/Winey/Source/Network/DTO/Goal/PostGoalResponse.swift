//
//  PostGoalResponse.swift
//  Winey
//
//  Created by 김인영 on 2023/07/20.
//

import Foundation

struct PostGoalResponse: Decodable {
    let userID, targetMoney: Int
    let targetDate, createdAt: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case targetMoney, targetDate, createdAt
    }
}
