//
//  MyFeedModel.swift
//  Winey
//
//  Created by 김응관 on 2023/07/19.
//

import UIKit

struct MyFeedModel: Hashable {
    let feedId: Int
    let userId: Int
    let nickName: String
    let feedTitle: String
    let feedImage: String
    let feedMoney: Int
    let likes: Int
    let createdAt: Date
    var isLiked: Bool
    let writerLevel: Int
}
