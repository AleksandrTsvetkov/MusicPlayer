//
//  MainTabBarController.swift
//  MusicPlayer
//
//  Created by Александр Цветков on 03.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBar.tintColor = #colorLiteral(red: 1, green: 0, blue: 0.3764705882, alpha: 1)
        
        let searchVC = SearchViewController()
        let libraryVC = ViewController()
        let searchNC = generateViewController(rootViewController: searchVC, image: UIImage(named: "Search"), title: "Search")
        let libraryNC = generateViewController(rootViewController: libraryVC, image: UIImage(named: "Library"), title: "Library")
        viewControllers = [searchNC, libraryNC]
    }
    
    private func generateViewController(rootViewController: UIViewController, image: UIImage?, title : String) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.image = image
        navigationController.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
}
