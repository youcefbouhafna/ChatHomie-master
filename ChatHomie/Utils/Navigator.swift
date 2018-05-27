//
//  Navigator.swift
//  ChatHomie
//
//  Created by Youcef Bouhafna on 5/18/18.
//  Copyright © 2018 Youcef. All rights reserved.
//

import Foundation
import UIKit

/**
 class that handle the navigation functions
 */
class Navigator {
    
    /**
     function to present view controllers with specific navigation style
 */
   static func presentViewController(viewController: UIViewController, onParentViewController parentVC: UIViewController, style: NavigationStyle, animated: Bool = true) {
        if style == .modal {
            parentVC.present(viewController, animated: animated, completion: nil)
        } else if style == .stack {
            parentVC.navigationController?.pushViewController(viewController, animated: animated)
        }
    }
    
    static func showPrivacyPolicy(onParentVC parentVC: UIViewController, withStyle style: NavigationStyle, animated: Bool = true) {
        let viewController = PrivacyViewController()
        presentViewController(viewController: viewController, onParentViewController: parentVC, style: style)
    }
    
    static func showProfile(onParentVC parentVC: UIViewController, withStyle style: NavigationStyle, animated: Bool = true) {
        let viewController = ProfileSettingsViewController()
        presentViewController(viewController: viewController, onParentViewController: parentVC, style: style)
    }
    
    static func showDonateVC(onParentVC parentVC: UIViewController, withStyle style: NavigationStyle, animated: Bool = true) {
        let viewController = DonateViewController()
        presentViewController(viewController: viewController, onParentViewController: parentVC, style: style)
    }
    
}

/**
 Enum for the navigation style
 */
enum NavigationStyle {
    case stack
    case modal
}
