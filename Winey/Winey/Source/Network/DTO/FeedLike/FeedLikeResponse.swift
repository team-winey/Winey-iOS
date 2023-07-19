//
//  FeedLikeResponse.swift
//  Winey
//
//  Created by 김인영 on 2023/07/19.
//

import Foundation

struct FeedLikeResponse: Codable {
    let feedID: Int
    let isLiked: Bool
    let likes: Int

    enum CodingKeys: String, CodingKey {
        case feedID = "feedId"
        case isLiked, likes
    }
}
