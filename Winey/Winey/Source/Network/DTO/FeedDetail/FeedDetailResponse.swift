//
//  FeedDetailResponse.swift
//  Winey
//
//  Created by Woody Lee on 2023/08/11.
//

import Foundation

struct FeedDetailResponse: Decodable {
    var getFeedResponseDto: FeedResponse
    var getCommentResponseList: [CommentResponse]
}
