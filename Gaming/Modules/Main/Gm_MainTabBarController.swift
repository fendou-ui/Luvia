//
//  Gm_MainTabBarController.swift
//  Gaming
//
//  主TabBar控制器

import UIKit

class Gm_MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gm_setupTabBar()
        gm_setupViewControllers()
    }
    
    private func gm_setupTabBar() {
        tabBar.backgroundColor = UIColor(red: 0.08, green: 0.08, blue: 0.12, alpha: 1.0)
        tabBar.barTintColor = UIColor(red: 0.08, green: 0.08, blue: 0.12, alpha: 1.0)
        tabBar.isTranslucent = false
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.5)
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 0.08, green: 0.08, blue: 0.12, alpha: 1.0)
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    private func gm_setupViewControllers() {
        let homeVC = Gm_HomeViewController()
        homeVC.tabBarItem = gm_createTabBarItem(
            selectedImage: "tab_main_100",
            unselectedImage: "tab_main_1001"
        )
        
        let searchVC = Gm_SearchViewController()
        searchVC.tabBarItem = gm_createTabBarItem(
            selectedImage: "tab_search_100",
            unselectedImage: "tab_search_1001"
        )
        
        let messageVC = Gm_MessageViewController()
        messageVC.tabBarItem = gm_createTabBarItem(
            selectedImage: "tab_message_100",
            unselectedImage: "tab_message_1001"
        )
        
        let mineVC = Gm_MineViewController()
        mineVC.tabBarItem = gm_createTabBarItem(
            selectedImage: "tab_mine_100",
            unselectedImage: "tab_mine_1001"
        )
        
        viewControllers = [
            UINavigationController(rootViewController: homeVC),
            UINavigationController(rootViewController: searchVC),
            UINavigationController(rootViewController: messageVC),
            UINavigationController(rootViewController: mineVC)
        ]
    }
    
    private func gm_createTabBarItem(selectedImage: String, unselectedImage: String) -> UITabBarItem {
        let item = UITabBarItem()
        item.image = UIImage(named: unselectedImage)?.withRenderingMode(.alwaysOriginal)
        item.selectedImage = UIImage(named: selectedImage)?.withRenderingMode(.alwaysOriginal)
        item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        return item
    }
}
