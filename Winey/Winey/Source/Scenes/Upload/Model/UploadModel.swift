//
//  UploadModel.swift
//  Winey
//
//  Created by 김응관 on 2023/07/19.
//

import Foundation

import UIKit

struct UploadModel: Codable {
    var feedTitle: String
    var feedMoney: Int
    
    init(_ feedTitle: String, _ feedMoney: Int) {
        self.feedTitle = feedTitle
        self.feedMoney = feedMoney
    }
}
