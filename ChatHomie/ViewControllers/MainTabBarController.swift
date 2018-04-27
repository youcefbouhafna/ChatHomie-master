//
//  MainTabBarController.swift
//  ChatHomie
//
//  Created by Youcef Bouhafna on 4/10/18.
//  Copyright © 2018 Youcef. All rights reserved.
//

import UIKit

/**
 App Main TabBar Controller Class jkjbhjhkjhkjhkjh
*/
let mainTabBar = MainTabBarController()
class MainTabBarController: UITabBarController {
    let userLists = UserListViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarItem()
    }
    
    /**
     Set tab bar items
    */
    func setupTabBarItem() {
            let usersListVC = UserListViewController()
            let conversationsVC = ConversationsViewController()
            let settingsVC = SettingsViewController()
            let viewControllerList = [ usersListVC, conversationsVC, settingsVC ]
            usersListVC.tabBarItem.image = #imageLiteral(resourceName: "usersIcon")
            conversationsVC.tabBarItem.image = #imageLiteral(resourceName: "messageIcon")
            settingsVC.tabBarItem.image = #imageLiteral(resourceName: "settingsIcon")
            setViewControllers(viewControllerList, animated: true)

    }
}
