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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers()
        setTabBar()
        setTestMenu()
        
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
        
        return nav
    }
    
    private func setTabBar() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .winey_purple400
        tabBar.unselectedItemTintColor = .winey_gray300
        tabBar.backgroundImage = UIImage()
    }
}

private extension TabBarController {
    enum Const {
        static let tabBarAttributes: [NSAttributedString.Key: Any] = [
            .font: Typography.font(style: .detail2, weight: .Medium)
        ]
    }
}

// MARK: - Test menu

extension TabBarController {
    func setTestMenu() {
        let logoLongPress = UILongPressGestureRecognizer(
            target: self,
            action: #selector(hanldeLongPress)
        )
        logoLongPress.minimumPressDuration = 1
        tabBar.addGestureRecognizer(logoLongPress)
    }
    
    @objc func hanldeLongPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        
        let testViewController = UINavigationController(rootViewController: TestViewController())

        present(testViewController, animated: true)
    }
}

extension TabBarController {
    private func getUser() {
        userService.getTotalUser() { [weak self] response in
            guard let response, let data = response.data else { return }
            guard let self else { return }
            
            // TODO: 레벨정보가 필요하다면 이곳에서 저장하고 사용합니다. 이것도 임시 구현 (시간 이슈)
            let hasGoal = data.userResponseGoalDto != nil
            UserSingleton.saveGoal(hasGoal)
            UserSingleton.saveNickname(data.userResponseUserDto.nickname)
            guard let level = UserLevel(rawValue: data.userResponseUserDto.userLevel) else { return }
            UserSingleton.saveLevel(level)
        }
    }
}
