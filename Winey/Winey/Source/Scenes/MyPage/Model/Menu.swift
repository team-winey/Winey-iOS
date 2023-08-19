//
//  Menu.swift
//  Winey
//
//  Created by 고영민 on 2023/08/09.
//

import UIKit

@frozen
enum Menu {
    case myfeed
    case inquiry
    case serviceRule
    case logout
    
    var title: String {
        switch self {
        case .myfeed:
            return "마이피드"
        case .inquiry:
            return "1:1문의"
        case .serviceRule:
            return "이용약관"
        case .logout:
            return "로그아웃"
        }
    }
}

enum MypageAlert {
    case logOut
    case withDraw
    
    var title: String {
        switch self {
        case .logOut:
            return "정말 로그아웃하시겠어요?"
        case .withDraw:
            return "정말로 떠나시겠어요?"
        }
    }
    
    var subTitle: String {
        switch self {
        case .logOut:
            return "로그아웃 후 장기간 미접속 시\n레벨이 내려갈 수 있습니다."
        case .withDraw:
            return "세이버와 함께한 절약을 잊지 말아주세요.\n탈퇴 시, 계정은 삭제되며 복구되지 않습니다."
        }
    }
    
    var leftBtnText: String {
        switch self {
        case .logOut:
            return "취소"
        case .withDraw:
            return "탈퇴하기"
        }
    }
    
    var rightBtnText: String {
        switch self {
        case .logOut:
            return "로그아웃하기"
        case .withDraw:
            return "머무르기"
        }
    }
}
