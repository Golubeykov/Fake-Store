//
//  TabBarConfigurator.swift
//  Fake Store
//
//  Created by Антон Голубейков on 27.09.2022.
//

import Foundation

import UIKit

class TabBarConfigurator {
    private let allTabs: [TabBarModel] = [.catalog, .favorites, .cart, .profile]
    
    func configure() -> UITabBarController {
        return constructTabBarController()
    }
}

private extension TabBarConfigurator {
    func constructTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = ColorsStorage.black
        tabBarController.tabBar.unselectedItemTintColor = ColorsStorage.lightGray
        tabBarController.tabBar.backgroundColor = ColorsStorage.white
        tabBarController.viewControllers = getControllers()
        return tabBarController
    }
    
    func getControllers() -> [UIViewController] {
        var viewControllers = [UIViewController]()
        
        allTabs.forEach { tab in
            let viewController = getCurrentViewController(tab: tab)
            let navigationController = UINavigationController(rootViewController: viewController)
            let tabBarItem = UITabBarItem(title: tab.title, image: tab.image, selectedImage: tab.selectedImage)
            viewController.tabBarItem = tabBarItem
            viewControllers.append(navigationController)
        }
        return viewControllers
    }
    
    func getCurrentViewController(tab: TabBarModel) -> UIViewController {
        switch tab {
        case .catalog:
            return CatalogViewController()
        case .favorites:
            return UIViewController()
        case .cart:
            return UIViewController()
        case .profile:
            return UIViewController()
        }
    }
}
