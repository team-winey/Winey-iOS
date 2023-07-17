////
////  NavigationBarType.swift
////  AppZam_Practice
////
////  Created by 김응관 on 2023/07/08.
////
//
//import UIKit
//
//enum NavigationBarType: String {
//    
//    // 1. X 버튼만 있는 네비바
//    // 2. 뒤로가기 버튼만 있는 네비바
//    
//    case uploadDismissBar
//    case backBar
//    
//    var title: String {
//        switch self {
//        default: return ""
//        }
//    }
//    
//    var leading: CGFloat {
//        switch self {
//        case .backBar:
//            return 14
//        case .uploadDismissBar:
//            return 12
//        }
//    }
//    
//    var width: CGFloat {
//        switch self {
//        case .backBar:
//            return 20
//        case .uploadDismissBar:
//            return 24
//        }
//    }
//    
//    var height: CGFloat {
//        switch self {
//        case .backBar:
//            return 20
//        case .uploadDismissBar:
//            return 24
//        }
//    }
//}
