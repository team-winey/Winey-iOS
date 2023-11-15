//
//  FeedModel.swift
//  Winey
//
//  Created by 김인영 on 2023/07/11.
//

import UIKit

struct FeedModel: Hashable {
    let feedId: Int
    let userId: Int
    let nickname: String
    let title: String
    let image: String
    let money: Int
    var like: Int
    var isLiked: Bool
    let writerLevel: Int
    let profileImage: UIImage?
    let comments: Int
    let timeAgo: String
}
