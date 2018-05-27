//
//  ProfileSettingsViewController.swift
//  ChatHomie
//
//  Created by Youcef Bouhafna on 5/18/18.
//  Copyright © 2018 Youcef. All rights reserved.
//

import UIKit

class ProfileSettingsViewController: UIViewController {

    lazy var photosView: UIView = {
        let stackView = UIView()
        stackView.backgroundColor = .red
        return stackView
    }()
    
    lazy var profileDescriptionView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupViews()
    }
    
    /**
     Setup views constraints
    */
    func setupViews() {
        self.view.addSubview(photosView)
        self.view.addSubview(profileDescriptionView)
        photosView.setConstraints(top: self.view.topAnchor, bottom: profileDescriptionView.topAnchor, trailing: self.view.trailingAnchor, leading: self.view.leadingAnchor, constant: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: self.view.frame.width, height: self.view.frame.height / 2))
        profileDescriptionView.setConstraints(top: photosView.bottomAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor, leading: self.view.leadingAnchor, constant: .init(top: 0, left: 0, bottom: 0, right: 0) , size: .init(width: self.view.frame.width, height: self.view.frame.height / 2))
    }
}
