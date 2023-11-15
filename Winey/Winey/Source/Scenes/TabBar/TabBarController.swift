//
//  TabBarController.swift
//  Winey
//
//  Created by 김인영 on 2023/07/05.
//

import DesignSystem
import UIKit

final class TabBarController: UITabBarController {
    
    private let userService = UserService()
    private var selectedIndexCache: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers()
        setTabBar()
        
        getUser()
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
        
        nav.interactivePopGestureRecognizer?.isEnabled = true
        nav.interactivePopGestureRecognizer?.delegate = self
        
        return nav
    }
    
    private func setTabBar() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .winey_purple400
        tabBar.unselectedItemTintColor = .winey_gray300
        tabBar.backgroundImage = UIImage()
        self.delegate = self
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let feedViewController = viewController.children.first(where: { $0 is FeedViewController }) as? FeedViewController {
            if selectedIndexCache == tabBarController.selectedIndex {
                feedViewController.scrollToTop()
            }
        }

        selectedIndexCache = tabBarController.selectedIndex
    }
}

private extension TabBarController {
    enum Const {
        static let tabBarAttributes: [NSAttributedString.Key: Any] = [
            .font: Typography.font(style: .detail2, weight: .Medium)
        ]
    }
}

extension TabBarController {
    private func getUser() {
        userService.getTotalUser() { response in
            guard let response, let data = response.data else { return }
            
            // TODO: 레벨정보가 필요하다면 이곳에서 저장하고 사용합니다. 이것도 임시 구현 (시간 이슈)
            let hasGoal = data.userResponseGoalDto != nil
            UserSingleton.saveId(data.userResponseUserDto.userID)
            UserSingleton.saveGoal(hasGoal)
            UserSingleton.saveNickname(data.userResponseUserDto.nickname)
            guard let level = UserLevel(rawValue: data.userResponseUserDto.userLevel) else { return }
            UserSingleton.saveLevel(level)
        }
    }
}

extension TabBarController: UIGestureRecognizerDelegate  {}
