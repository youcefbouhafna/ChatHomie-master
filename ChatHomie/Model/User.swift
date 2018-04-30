//
//  User.swift
//  ChatHomie
//
//  Created by youcef bouhafna on 7/27/17.
//  Copyright © 2017 Youcef. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class User: NSObject {
    var userName: String
    var email: String
    var id: String
    var profileImageUrl: String
    
    init(userName: String, email: String, id: String, profileImgURL: String) {
        self.userName = userName
        self.email = email
        self.id = id
        self.profileImageUrl = profileImgURL
    }
    
    init(withDictionary dictionary: [String: Any]) {
        self.userName = dictionary["userName"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.id = dictionary["id"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
    
  
}
