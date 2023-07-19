//
//  UploadModel.swift
//  Winey
//
//  Created by 김응관 on 2023/07/19.
//

import Foundation

struct UploadModel: Codable {
    let feedImage: String
    let feedTitle: String
    let feedPrcie: Int
    
    init(_ feedImage: String, _ feedTitle: String, _ feedPrcie: Int) {
        self.feedImage = feedImage
        self.feedTitle = feedTitle
        self.feedPrcie = feedPrcie
    }
}
