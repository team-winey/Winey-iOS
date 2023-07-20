//
//  TotalRecommendResponse.swift
//  Winey
//
//  Created by 김인영 on 2023/07/20.
//

import Foundation

struct TotalRecommendResponse: Decodable {
    let pageResponseDto: PageResponseDto
    let recommendsResponseDto: [RecommendsResponseDto]
}

struct PageResponseDto: Decodable {
    let totalPageSize: Int
    let currentPageIndex: Int
    let isEnd: Bool
}

struct RecommendsResponseDto: Decodable {
    let recommendID: Int
    let recommendLink: String?
    let recommendTitle: String
    let recommendDiscount: String
    let recommendImage: String
    let recommendSubtitle: String?

    enum CodingKeys: String, CodingKey {
        case recommendID = "recommendId"
        case recommendLink
        case recommendTitle
        case recommendDiscount
        case recommendImage
        case recommendSubtitle = "recommendSubTitle"
    }
}
