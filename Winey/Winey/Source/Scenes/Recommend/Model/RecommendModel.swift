//
//  RecommendModel.swift
//  Winey
//
//  Created by 김인영 on 2023/07/13.
//

import UIKit

struct RecommendModel: Hashable {
    let id: Int
    let link: String
    let title: String
    let subTitle: String
    let discount: String
    let image: UIImage
}
