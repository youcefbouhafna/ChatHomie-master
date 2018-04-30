//
//  CompleteProfileViewController.swift
//  ChatHomie
//
//  Created by youcef bouhafna on 10/11/17.
//  Copyright © 2017 Youcef. All rights reserved.
//

import UIKit
import Foundation
import SwiftMessages

class CompleteProfileViewController: UIViewController, UINavigationBarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var StatesList = [String]()
    var imagePicker = UIImagePickerController()
    var profilePhotoHeight: NSLayoutConstraint?
    var statesPickerHeight: NSLayoutConstraint?
    var profile: LoginViewController?
    var userID: String?
    /**
     View that holds the profile image
 */
    
    var userName: UILabel = {
        var nameLabel = UILabel()
        return nameLabel
    }()
    
    var profileImage: UIImageView = {
        var sampleImage = UIImageView()
        sampleImage.image = #imageLiteral(resourceName: "sampleProfileImage")
        sampleImage.translatesAutoresizingMaskIntoConstraints = false
        return sampleImage
    }()
    
    var stackViewContainer: UIStackView = {
        var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.axis = .vertical
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        profileImage.tintColor = .red
        userName.text = userID
        
    }
    
    func setupViews() {
        view.addSubview(stackViewContainer)
        stackViewContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        stackViewContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        stackViewContainer.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0).isActive = true
        
        // profile image
        stackViewContainer.addArrangedSubview(profileImage)
        profileImage.topAnchor.constraint(equalTo: stackViewContainer.topAnchor, constant: 0).isActive = true
        profileImage.widthAnchor.constraint(equalTo: stackViewContainer.widthAnchor, constant: 0).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: stackViewContainer.frame.height / 2 - 20).isActive = true
        
        // stackView
//        stackViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
//        stackViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
//        stackViewContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
//        stackViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
      
        
        
    }

    
    /// set the uplodPhoto icon to the profile image selected
}
