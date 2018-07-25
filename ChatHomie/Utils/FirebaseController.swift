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
    
    static func status(uid: String = "") {
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        let ref = Database.database().reference().child("Users")
        let onlineStatus = ref.child(uid)
        connectedRef.observe(.value) { (snapshot) in
            if let connected = snapshot.value as? Bool,
                connected {
                ref.observe(.value) { (snapshot) in
                    guard snapshot.hasChild(uid) else {return}
                        onlineStatus.updateChildValues(["isOnline": true], withCompletionBlock: { (error, data) in
                            if let error = error {
                                assertionFailure(error.localizedDescription)
                            }
                        })
                    
                }
            } else {
                onlineStatus.updateChildValues(["isOnline": false])
            }
        }
        
    }
}
