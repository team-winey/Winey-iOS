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
    case delectingAccount
    case logout
    
    var title: String {
        switch self {
        case .myfeed:
            return "마이피드"
        case .inquiry:
            return "1:1문의"
        case .delectingAccount:
            return "회원탈퇴"
        case .logout:
            return "로그아웃"
        }
    }
}
