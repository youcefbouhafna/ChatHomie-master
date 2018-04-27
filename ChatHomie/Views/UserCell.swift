//
//  UserCell.swift
//  ChatHomie
//
//  Created by youcef bouhafna on 9/25/17.
//  Copyright © 2017 Youcef. All rights reserved.
//

import UIKit

class UserCell: UICollectionViewCell {
    
    let profileImage: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let cellUserName: UILabel = {
        let name = UILabel()
        name.textColor = .black
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupUserCell()
        

    }
    
    override func layoutSubviews() {
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
    }
   
    func setupUserCell() {
        addSubview(profileImage)
        addSubview(cellUserName)
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImage.rightAnchor.constraint(equalTo: cellUserName.leftAnchor, constant: -20).isActive = true
        profileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 8).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        cellUserName.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        cellUserName.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        cellUserName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 8).isActive = true
        cellUserName.heightAnchor.constraint(equalToConstant: 20).isActive = true
       

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented correctly")
    }
}
