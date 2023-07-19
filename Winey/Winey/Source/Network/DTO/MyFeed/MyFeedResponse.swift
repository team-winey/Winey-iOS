////
////  MyFeedResponse.swift
////  Winey
////
////  Created by 김응관 on 2023/07/19.
////
//
//import Foundation
//
//// MARK: - Data
//struct MyFeedResponse: Codable {
//    let pageResponseDto: PageResponseDto
//    let getFeedResponseDtoList: [GetFeedResponseDtoList]
//    
//    enum CodingKeys: String, CodingKey {
//        case pageResponse = "pageResponseDto"
//        case getFeedResponseList = "getFeedResponseDtoList"
//    }
//}
//
//// MARK: - GetFeedResponseDtoList
//struct GetFeedResponseDtoList: Codable {
//    let feedID, userID: Int
//    let nickName: String
//    let writerLevel: Int
//    let feedTitle: String
//    let feedImage: String
//    let feedMoney: Int
//    let isLiked: Bool
//    let likes: Int
//    let createdAt: String
//    
//    enum CodingKeys: String, CodingKey {
//        case feedID = "feedId"
//        case userID = "userId"
//        case nickname = "nickName"
//        case title = "feedTitle"
//        case image = "feedImage"
//        case money = "feedMoney"
//        case writerLevel, isLiked, likes, createdAt
//    }
//}
//
//// MARK: - PageResponseDto
//struct PageResponseDto: Codable {
//    let totalPageSize, currentPageIndex: Int
//    let isEnd: Bool
//}

