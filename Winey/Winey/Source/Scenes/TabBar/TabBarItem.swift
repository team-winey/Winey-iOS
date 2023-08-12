//
//  TabBarItem.swift
//  Winey
//
//  Created by Woody Lee on 2023/07/11.
//

import DesignSystem
import UIKit

enum TabBarItem: CaseIterable {
    case feed
    case recommend
    case mypage
    
    var title: String {
        switch self {
        case .feed:         return "피드"
        case .recommend:    return "추천"
        case .mypage:       return "마이페이지"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .feed:         return .Icon.feed
        case .recommend:    return .Icon.recommend
        case .mypage:       return .Icon.mypage
        }
    }
    
    var rootViewController: UIViewController {
        switch self {
        case .feed:         return FeedViewController()
        case .recommend:    return RecommendViewController()
        case .mypage:       return AlertViewController()
        }
    }
}
