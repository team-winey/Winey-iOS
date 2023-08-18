//
//  NotificationResponse.swift
//  Winey
//
//  Created by 고영민 on 2023/08/16.
//

import Foundation

struct TotalNotificationResponse: Codable {
    let getNotiResponseDtoList: [GetNotiResponseDtoList]
}

// MARK: - GetNotiResponseDtoList
struct GetNotiResponseDtoList: Codable {
    let notiID: Int
    let notiReceiver, notiMessage, notiType: String
    let isChecked: Bool
    let timeAgo, createdAt: String
    let linkID: Int?

    enum CodingKeys: String, CodingKey {
        case notiID = "notiId"
        case notiReceiver, notiMessage, notiType, isChecked, timeAgo, createdAt
        case linkID = "linkId"
    }
}
