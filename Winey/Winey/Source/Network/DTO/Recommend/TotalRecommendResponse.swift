//
//  TotalRecommendResponse.swift
//  Winey
//
//  Created by 김인영 on 2023/07/20.
//

import Foundation

struct TotalRecommendResponse: Codable {
    let pageResponseDto: PageResponseDto
    let recommendsResponseDto: [RecommendsResponseDto]
}

// MARK: - PageResponseDto
struct PageResponseDto: Codable {
    let totalPageSize, currentPageIndex: Int
    let isEnd: Bool
}

// MARK: - RecommendsResponseDto
struct RecommendsResponseDto: Codable {
    let recommendID: Int
    let recommendLink, recommendTitle, recommendDiscount, recommendImage: String
    let createdAt: String
    let recommendSubTitle: String?

    enum CodingKeys: String, CodingKey {
        case recommendID = "recommendId"
        case recommendLink, recommendTitle, recommendDiscount, recommendImage, createdAt, recommendSubTitle
    }
}
