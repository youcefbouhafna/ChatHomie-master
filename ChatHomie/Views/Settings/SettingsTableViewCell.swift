//
//  SettingsTableViewCell.swift
//  ChatHomie
//
//  Created by Youcef Bouhafna on 5/14/18.
//  Copyright © 2018 Youcef. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    let settingItemIcon: UIImageView = {
        let itemImage = UIImageView()
        itemImage.translatesAutoresizingMaskIntoConstraints = false
        return itemImage
    }()
    
    let settingTitle: UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    func setupViews() {
        self.addSubview(settingItemIcon)
        self.addSubview(settingTitle)
        
        settingTitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        settingTitle.leftAnchor.constraint(equalTo: settingItemIcon.rightAnchor, constant: 8).isActive = true
        settingTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        settingTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        
        settingItemIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        settingItemIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        settingItemIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        settingItemIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
    }
    
    func configWith(setting: SettingsItems) {
        settingItemIcon.image = setting.icon
        settingTitle.text = setting.title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
