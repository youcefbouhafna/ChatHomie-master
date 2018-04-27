//
//  SettingsViewController.swift
//  ChatHomie
//
//  Created by Youcef Bouhafna on 4/10/18.
//  Copyright © 2018 Youcef. All rights reserved.
//

import UIKit

/**
 Settings class to manage all app settings
*/
class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.title = "Settings"
    }

    
}
