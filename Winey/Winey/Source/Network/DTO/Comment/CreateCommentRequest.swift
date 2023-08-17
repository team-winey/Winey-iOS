//
//  CreateCommentRequest.swift
//  Winey
//
//  Created by Woody Lee on 2023/08/10.
//

import Foundation

struct CreateCommentRequest: Encodable {
    let feedId: Int
    let content: String
}
