//
//  SettingsModel.swift
//  ChatHomie
//
//  Created by Youcef Bouhafna on 5/14/18.
//  Copyright © 2018 Youcef. All rights reserved.
//

import Foundation
import UIKit

/**
 Class that represent the setting model
 */
class SettingsModel {
    let settingItem: SettingsItems
    var title: String {
        return settingItem.title ?? ""
    }
    var icon: UIImage {
        return settingItem.icon ?? UIImage()
    }
    
    init(settingItem: SettingsItems) {
        self.settingItem = settingItem
    }
    
}


/**
 An enum of settings items to display with titles and icons
 */
enum SettingsItems {
    case profileImages
    case privacyPolicy
    case notification
    case biometrics
    case reviewApp
    case donate
    
    var title: String? {
        switch self {
        case .profileImages: return "Profile Images"
        case .privacyPolicy: return "Privacy Policy"
        case .notification: return "Notification"
        case .biometrics: return "FaceID/TouchID"
        case .reviewApp: return "Help Us With A Review"
        case .donate: return "Help Us Keep The App Running"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .profileImages: return #imageLiteral(resourceName: "settings-profile")
        case .privacyPolicy: return #imageLiteral(resourceName: "settings-privacypolicy")
        case .notification: return #imageLiteral(resourceName: "settings-notification")
        case .biometrics: return #imageLiteral(resourceName: "settings-touchID")
        case .reviewApp: return #imageLiteral(resourceName: "settings-reviewapp")
        case .donate: return #imageLiteral(resourceName: "settings-donate")
        
        }
    }
    
    
}
