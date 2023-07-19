//
//  UploadModel.swift
//  Winey
//
//  Created by 김응관 on 2023/07/19.
//

import Foundation

import UIKit

struct UploadModel: Codable {
    typealias Cost = Int
    var feedTitle: String
    var feedMoney: Cost
    
    init(_ feedTitle: String, _ feedMoney: Int) {
        self.feedTitle = feedTitle
        self.feedMoney = feedMoney
    }
}
