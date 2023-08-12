//
//  MypageModel.swift
//  Winey
//
//  Created by 고영민 on 2023/08/05.
//

import UIKit

struct MypageMenuModel: Codable {
    let titleLabel: String
}

extension MypageMenuModel {
    static func firstSectionDummy() -> [MypageMenuModel] {
        return [MypageMenuModel(titleLabel: "마이피드")]
    }
    static func secondSectionDummy() -> [MypageMenuModel] {
        return [MypageMenuModel(titleLabel: "1:1 문의")]
    }
}
