//
//  TabBarController.swift
//  Winey
//
//  Created by 김인영 on 2023/07/05.
//

import DesignSystem
import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers()
        setTabBar()
    }
    
    private func setViewControllers() {
        let viewControllers = TabBarItem.allCases
            .map { navigationController(with: $0, rootViewController: $0.rootViewController) }
        
        self.viewControllers = viewControllers
    }
    
    private func navigationController(
        with item: TabBarItem,
        rootViewController: UIViewController
    ) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
      
        nav.tabBarItem.image = item.image
        nav.tabBarItem.title = item.title
        nav.tabBarItem.setTitleTextAttributes(Const.tabBarAttributes, for: .normal)
        
        nav.navigationBar.backgroundColor = .clear
        nav.isNavigationBarHidden = true
        
        return nav
    }
    
    private func setTabBar() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .purple400
        tabBar.unselectedItemTintColor = .gray300
        tabBar.backgroundImage = UIImage()
    }
}

private extension TabBarController {
    enum Const {
        static let tabBarAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.font(.pretendardBold, ofSize: 12)]
    }
}
