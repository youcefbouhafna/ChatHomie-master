//
//  FirebaseController.swift
//  ChatHomie
//
//  Created by Youcef Bouhafna on 5/23/18.
//  Copyright © 2018 Youcef. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

/**
 Class that manages Firebase helper functions
 */
class FirebaseController {
    
    static func status(uid: String = "", isOnline: Bool) {
        let ref = Database.database().reference().child("Users")
        let onlineStatus = ref.child(uid)
        ref.observe(.value) { (snapshot) in
            if snapshot.hasChild(uid) {
                onlineStatus.updateChildValues(["isOnline": isOnline], withCompletionBlock: { (error, data) in
                    if let error = error {
                        assertionFailure(error.localizedDescription)
                    }
                })
            }
        }        
    }
}
