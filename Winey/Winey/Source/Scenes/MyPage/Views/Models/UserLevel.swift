//
//  UserLevel.swift
//  Winey
//
//  Created by 고영민 on 2023/07/19.
//

import UIKit

import DesignSystem

enum UserLevel: String {
    case none = ""
    case one = "평민"
    case two = "기사"
    case three = "귀족"
    case four = "황제"
}

extension UserLevel {
   
    var characterImage: UIImage? {
        switch self {
        case .none: return nil
        case .one: return .Img.mypage_level_one
        case .two: return .Img.mypage_level_two
        case .three: return .Img.mypage_level_three
        case .four: return.Img.mypage_level_four
        }
    }
    
    var progressbarImage: UIImage? {
        switch self {
        case .none: return nil
        case .one: return .Img.progressbar_level_one
        case .two: return .Img.progressbar_level_two
        case .three: return .Img.progressbar_level_three
        case .four: return .Img.progressbar_level_four
        }
    }
}
