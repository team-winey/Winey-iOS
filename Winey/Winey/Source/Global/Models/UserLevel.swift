//
//  UserLevel.swift
//  Winey
//
//  Created by 고영민 on 2023/07/19.
//

import UIKit

import DesignSystem

enum UserLevel: String, CaseIterable {
    case one = "평민"
    case two = "기사"
    case three = "귀족"
    case four = "황제"
    case none = ""
}

extension UserLevel {
    init?(value: Int) {
        self.init(rawValue: UserLevel.allCases[value - 1].rawValue)
    }
}

extension UserLevel {
    var profileImage: UIImage? {
        switch self {
        case .one: return .Img.profile_level_one
        case .two: return .Img.profile_level_two
        case .three: return .Img.profile_level_three
        case .four: return .Img.profile_level_four
        case .none: return nil
        }
    }
    
    var characterImage: UIImage? {
        switch self {
        case .one: return .Img.mypage_level_one
        case .two: return .Img.mypage_level_two
        case .three: return .Img.mypage_level_three
        case .four: return.Img.mypage_level_four
        case .none: return nil
        }
    }
    
    var progressbarImage: UIImage? {
        switch self {
        case .one: return .Img.progressbar_level_one
        case .two: return .Img.progressbar_level_two
        case .three: return .Img.progressbar_level_three
        case .four: return .Img.progressbar_level_four
        case .none: return nil
        }
    }
}
