//
//  CreateCommentResponse.swift
//  Winey
//
//  Created by Woody Lee on 2023/08/11.
//

import Foundation

struct CreateCommentResponse: Decodable {
    let commentId: Int?
    let commentCounter: Int?
    let author: String?
    let content: String?
}
