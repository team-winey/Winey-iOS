//
//  FeedModel.swift
//  Winey
//
//  Created by 김인영 on 2023/07/11.
//

import UIKit

struct FeedModel: Hashable {
    let id: Int
    let nickname: String
    let title: String
    let image: UIImage
    let money: Int
    let like: Int
    var isLiked: Bool
    let writerLevel: Int
}
