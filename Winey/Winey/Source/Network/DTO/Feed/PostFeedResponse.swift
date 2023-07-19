//
//  FeedPostResponse.swift
//  Winey
//
//  Created by 김응관 on 2023/07/19.
//

import Foundation

struct PostFeedResponse: Decodable {
    let feedID: Int
    let createdAt: Date
}
