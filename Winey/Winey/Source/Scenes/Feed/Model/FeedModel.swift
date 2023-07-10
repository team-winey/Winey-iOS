//
//  FeedModel.swift
//  Winey
//
//  Created by 김인영 on 2023/07/11.
//

import UIKit

struct FeedModel: Hashable {
    let feedId: Int
    let nickname: String
    let feedTitle: String
    let feedImage: UIImage
    let feedMoney: Int
    let likes: Int
    var isLiked: Bool
    let createdAt: Date
    let writerLevel: Int
}

let itemdummy = [
    FeedModel(feedId: 1, nickname: "뇽잉깅", feedTitle: "절약타이틀", feedImage: UIImage(), feedMoney: 2000, likes: 2, isLiked: true, createdAt: Date(), writerLevel: 1),
    FeedModel(feedId: 2, nickname: "뇽잉깅", feedTitle: "절약타이틀1", feedImage: UIImage(), feedMoney: 2000, likes: 2, isLiked: true, createdAt: Date(), writerLevel: 1),
    FeedModel(feedId: 3, nickname: "뇽잉깅", feedTitle: "절약타이틀2", feedImage: UIImage(), feedMoney: 2000, likes: 2, isLiked: true, createdAt: Date(), writerLevel: 1),
    FeedModel(feedId: 4, nickname: "뇽잉깅", feedTitle: "절약타이틀3", feedImage: UIImage(), feedMoney: 2000, likes: 2, isLiked: true, createdAt: Date(), writerLevel: 1),
    FeedModel(feedId: 5, nickname: "뇽잉깅", feedTitle: "절약타이틀4", feedImage: UIImage(), feedMoney: 2000, likes: 2, isLiked: true, createdAt: Date(), writerLevel: 1),
    FeedModel(feedId: 6, nickname: "뇽잉깅", feedTitle: "절약타이틀5", feedImage: UIImage(), feedMoney: 2000, likes: 2, isLiked: true, createdAt: Date(), writerLevel: 1)
    ]
