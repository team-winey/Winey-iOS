//
//  TabBarController.swift
//  Winey
//
//  Created by 김인영 on 2023/07/05.
//

import UIKit
import DesignSystem

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers()
        setTabBar()
    }
    
    private func setViewControllers() {
        
        let feedVC = makeNavigationController(
            unselectedImage: .TabBar.feed,
            selectedImage: .TabBar.feed,
            rootViewController: UIViewController(), title: "피드")
        
        let recommendVC = makeNavigationController(
            unselectedImage: .TabBar.recommend,
            selectedImage: .TabBar.recommend,
            rootViewController: UIViewController(), title: "추천")
        
        let myPageVC = makeNavigationController(
            unselectedImage: .TabBar.myPage,
            selectedImage: .TabBar.myPage,
            rootViewController: UIViewController(), title: "마이페이지")
        
        viewControllers = [feedVC, recommendVC, myPageVC]
    }
    
    private func makeNavigationController(unselectedImage: UIImage?, selectedImage: UIImage?, rootViewController: UIViewController, title: String) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.tabBarItem.title = title
        
        nav.navigationBar.tintColor = .purple400
        nav.navigationBar.backgroundColor = .clear
        nav.isNavigationBarHidden = true
        nav.navigationBar.isHidden = true
        nav.tabBarItem.setTitleTextAttributes([.font: UIFont.font(.pretendardBold, ofSize: 12)], for: .normal)
        nav.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: nil)
        nav.navigationItem.backBarButtonItem?.tintColor = .purple400
        
        return nav
    }
    
    private func setTabBar() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .purple400
        tabBar.unselectedItemTintColor = .gray300
        tabBar.backgroundImage = UIImage()
    }
}
