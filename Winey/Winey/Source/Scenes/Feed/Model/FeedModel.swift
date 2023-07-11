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
    FeedModel(feedId: 1, nickname: "뇽잉깅", feedTitle: "절약타이틀 어쩌고저쩌고 숄라숄라 뿡뿅ㅃ잉일", feedImage: UIImage(), feedMoney: 2000, likes: 2, isLiked: true, createdAt: Date(), writerLevel: 1),
    FeedModel(feedId: 2, nickname: "뇽잉깅", feedTitle: "절약타이틀1아렁라ㅓ알알아러아ㅓㄹ아ㅓ라어라어ㅏ러아", feedImage: UIImage(), feedMoney: 29900, likes: 2, isLiked: true, createdAt: Date(), writerLevel: 1),
    FeedModel(feedId: 3, nickname: "뇽잉깅", feedTitle: "절약타이틀210210291021029012", feedImage: UIImage(), feedMoney: 200, likes: 2, isLiked: true, createdAt: Date(), writerLevel: 1),
    FeedModel(feedId: 4, nickname: "뇽잉깅", feedTitle: "절약타이틀3아아니 아아러니아런ㅇㄹ 아러아ㅓ라어라어라어라어ㅏ", feedImage: UIImage(), feedMoney: 2000, likes: 2, isLiked: true, createdAt: Date(), writerLevel: 1),
    FeedModel(feedId: 5, nickname: "뇽잉깅", feedTitle: "절약타이틀4ㅓ2ㅓ2ㅓ2ㅓ2ㅓ2ㅓ2", feedImage: UIImage(), feedMoney: 10000, likes: 2, isLiked: true, createdAt: Date(), writerLevel: 1),
    FeedModel(feedId: 6, nickname: "뇽잉깅", feedTitle: "절약타이틀52332323", feedImage: UIImage(), feedMoney: 20, likes: 2, isLiked: true, createdAt: Date(), writerLevel: 1)
    ]
