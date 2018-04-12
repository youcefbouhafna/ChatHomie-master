//
//  MainTabBarController.swift
//  ChatHomie
//
//  Created by Youcef Bouhafna on 4/10/18.
//  Copyright © 2018 Youcef. All rights reserved.
//

import UIKit

/**
 App Main TabBar Controller Class
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
        self.tabBar.items?[0].title = "Users"
        let conversationsVC = ConversationsViewController()
        self.tabBar.items?[1].title = "Conversations"
        let settingsVC = SettingsViewController()
        self.tabBar.items?[2].title = "Settings"
        
        let viewControllerList = [ usersListVC, conversationsVC, settingsVC ]
        setViewControllers(viewControllerList, animated: true)
        
    }
}
