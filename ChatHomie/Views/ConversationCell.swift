//
//  ConversationCell.swift
//  ChatHomie
//
//  Created by youcef bouhafna on 10/28/17.
//  Copyright © 2017 Youcef. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
class ConversationCell: UITableViewCell {

    var message: Message? {
        didSet {
            setupNameAndProfileImage()
            if let seconds = message?.timeStamp?.doubleValue {
                let timeStampDate = Date(timeIntervalSince1970: seconds)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                //TODO: add time label in this file , setup constraints , then set it here
                
            }
        }
    }
    
    func setupNameAndProfileImage() {
        if let id = message?.chatPartnerId() {
            let ref = Database.database().reference().child("Users").child(id)
            ref.observe(.value, with: { (snapshot) in
                if let json = snapshot.value as? [String: AnyObject] {
                    self.userName.text = json["userName"] as? String
                    self.messageLabel.text = json["text"] as? String
                    if let profileImageUrl = json["profileImageUrl"] as? String {
                        self.profileImage.loadImageUsingCacheWithUrlString(profileImageUrl)
                    }
                }
            }, withCancel: nil)
        }
    }
    var messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont(name: "system", size: 14)
        return label
    }()
    let profileImage: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        
        return image
    }()
    
    var userName: UILabel = {
        let name = UILabel()
        name.textColor = .black
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        profileImage.layer.borderWidth = 1
        // profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
    }
    
    func setupUserCell() {
        addSubview(profileImage)
        addSubview(userName)
        addSubview(messageLabel)
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImage.rightAnchor.constraint(equalTo: userName.leftAnchor, constant: -20).isActive = true
        profileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 8).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        userName.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        userName.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        userName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 8).isActive = true
        userName.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 4).isActive = true
        messageLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 8).isActive = true
        
        
    }
 
}



