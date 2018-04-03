//
//  Message.swift
//  ChatHomie
//
//  Created by youcef bouhafna on 10/23/17.
//  Copyright © 2017 Youcef. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
class Message {
    var text: String?
    var sender: String?
    var receiver: String?
    var timeStamp: NSNumber?
    var imageURL: String?
    var videoURL: String?
    
    init?(dictionary: [String: AnyObject]) {
        self.text = dictionary["Text"] as? String
        self.sender = dictionary["sender"] as? String
        self.receiver = dictionary["receiver"] as? String
        self.imageURL = dictionary["imageURL"] as? String
        self.videoURL = dictionary["videoURL"] as? String
    }
    
    func chatPartnerId() -> String? {
        return sender == Auth.auth().currentUser?.uid ? receiver : sender
    }
    
}
