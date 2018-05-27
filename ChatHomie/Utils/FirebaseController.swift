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

class FirebaseAuthStatus {
    static func status(uid: String, isConnected: Bool, success: @escaping(Bool) -> Void) {
        let ref = Database.database().reference().child("Users").child(uid).child("isOnline")
        ref.setValue(isConnected) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                success(false)
            }
            
            success(true)
        }
        
    }
}
