//
//  TotalFeedResponse.swift
//  Winey
//
//  Created by 김인영 on 2023/07/17.
//

import Foundation

struct TotalFeedResponse: Decodable {
    let pageResponse: PageResponse
    let getFeedResponseList: [GetFeedResponseList]
    
    enum CodingKeys: String, CodingKey {
        case pageResponse = "pageResponseDto"
        case getFeedResponseList = "getFeedResponseDtoList"
    }
}

struct GetFeedResponseList: Decodable {
    let feedID, userID: Int
    let nickname: String
    let writerLevel: Int
    let title: String
    let image: String
    let money: Int
    let isLiked: Bool
    let likes: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case feedID = "feedId"
        case userID = "userId"
        case nickname = "nickName"
        case title = "feedTitle"
        case image = "feedImage"
        case money = "feedMoney"
        case writerLevel, isLiked, likes, createdAt
    }
}

struct PageResponse: Decodable {
    let totalPageSize, currentPageIndex: Int
    let isEnd: Bool
}
