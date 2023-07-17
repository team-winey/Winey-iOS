//
//  GetTotalFeedResponse.swift
//  Winey
//
//  Created by 김인영 on 2023/07/17.
//

import Foundation

// MARK: - DataClass
struct TotalFeedResponse: Codable {
    let pageResponseDto: PageResponse
    let getFeedResponseDtoList: [GetFeedResponseList]
}

// MARK: - GetFeedResponseDtoList
struct GetFeedResponseList: Codable {
    let feedID, userID: Int
    let nickName: String
    let writerLevel: Int
    let feedTitle: String
    let feedImage: String
    let feedMoney: Int
    let isLiked: Bool
    let likes: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case feedID = "feedId"
        case userID = "userId"
        case nickName, writerLevel, feedTitle, feedImage, feedMoney, isLiked, likes, createdAt
    }
}

// MARK: - PageResponseDto
struct PageResponse: Codable {
    let totalPageSize, currentPageIndex: Int
    let isEnd: Bool
}
