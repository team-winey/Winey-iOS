//
//  NicknameType.swift
//  Winey
//
//  Created by 김응관 on 2023/08/18.
//

import Foundation

struct NicknameType {
    public let naviExist: Bool
    public let titleLabel: String
    
    public init(naviExist: Bool, titleLabel: String) {
        self.naviExist = naviExist
        self.titleLabel = titleLabel
    }
}

enum NicknamePage {
    case onboarding
    case myPage
    
    var navigationExist: Bool {
        switch self {
        case .onboarding:
            return false
        case .myPage:
            return true
        }
    }
    
    var label: String {
        switch self {
        case .onboarding:
            return "위니제국에 들어온 당신,\n어떤 닉네임으로 불리고 싶나요?"
        case .myPage:
            return "위니제국의 국민인 당신,\n어떤 닉네임으로 바꾸고 싶나요?"
        }
    }
}
