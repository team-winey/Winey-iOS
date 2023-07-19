//
//  PostGoalRequest.swift
//  Winey
//
//  Created by 김인영 on 2023/07/20.
//

import Foundation

struct PostGoalRequest: Codable {
    let targetMoney: Int
    let targetDay: Int
}
