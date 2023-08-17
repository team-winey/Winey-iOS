//
//  CommentResponse.swift
//  Winey
//
//  Created by Woody Lee on 2023/08/11.
//

import Foundation

struct CommentResponse: Decodable {
    let commentId: Int
    let author: String
    let content: String
    let authorLevel: Int
    let createdAt: String
}
