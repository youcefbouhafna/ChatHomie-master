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
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let cellUserName: UILabel = {
        let name = UILabel()
        name.textColor = .black
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = UIFont(name: "system", size: 20)
        return name
    }()
    
    let userConnectionStatus: UILabel = {
        let status = UILabel()
        status.textColor = .black
        status.translatesAutoresizingMaskIntoConstraints = false
        status.font = UIFont.boldSystemFont(ofSize: 12)
        status.text = "online"
        return status
    }()
    
    lazy var userStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
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
        profileImage.layer.masksToBounds = true
    }
   
    func setupUserCell() {
        addSubview(profileImage)
        self.addSubview(userStackView)
        bringSubview(toFront: userStackView)
        userStackView.addArrangedSubview(cellUserName)
        userStackView.addArrangedSubview(userConnectionStatus)
        
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 8).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        userStackView.translatesAutoresizingMaskIntoConstraints = false

        userStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        userStackView.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor, constant: 0).isActive = true
        userStackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        userStackView.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 10).isActive = true

        cellUserName.heightAnchor.constraint(equalToConstant: 15).isActive = true
        userConnectionStatus.heightAnchor.constraint(equalToConstant: 15).isActive = true
       

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented correctly")
    }
}
