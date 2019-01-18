//
//  TabBarController.swift
//  Flickr Client
//
//  Created by Yassin Mziya on 1/12/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .white
        tabBar.barTintColor = UIColor.flickrDarkGray
        tabBar.isTranslucent = false
        
        let feedVC = FeedViewController()
        feedVC.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(named: "home"), selectedImage: UIImage(named: "home"))
        
        let searchVC = SearchViewController()
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "magnifying-glass"), selectedImage: UIImage(named: "magnifying-glass"))
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), selectedImage: UIImage(named: "profile"))
        
        let tabs = [
            feedVC,
            searchVC,
            profileVC
        ].map { vc -> UINavigationController in
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.navigationBar.barTintColor = .flickrGray
            navigationController.navigationBar.tintColor = .white
            navigationController.navigationBar.isHidden = true
            navigationController.navigationBar.isTranslucent = false
            return navigationController
        }
        
        viewControllers = tabs
    }

}
