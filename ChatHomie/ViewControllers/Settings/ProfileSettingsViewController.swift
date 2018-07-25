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
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var verticalPhotosStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 1
        return stackView
    }()
    
    lazy var horizontalPhotosStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 1
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 1
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    lazy var profileDescriptionView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()

    lazy var mainProfileImageView: UIImageView = {
        let profileImage = UIImageView()
        profileImage.image = #imageLiteral(resourceName: "youcef")
        profileImage.contentMode = .scaleAspectFill
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        return profileImage
    }()
    
    lazy var profileImageOne: UIImageView = {
        let imageOne = UIImageView()
        imageOne.image = #imageLiteral(resourceName: "youcef")
        imageOne.contentMode = .scaleAspectFill
        return imageOne
    }()
    
    lazy var profileImageTwo: UIImageView = {
        let imageTwo = UIImageView()
        imageTwo.image = #imageLiteral(resourceName: "youcef")
        imageTwo.contentMode = .scaleAspectFill
        return imageTwo
    }()
    
    lazy var profileImageThree: UIImageView = {
        let imageThree = UIImageView()
        imageThree.image = #imageLiteral(resourceName: "youcef")
        imageThree.contentMode = .scaleAspectFill
        return imageThree
    }()
    lazy var profileImageFour: UIImageView = {
        let imageFour = UIImageView()
        imageFour.image = #imageLiteral(resourceName: "youcef")
        imageFour.contentMode = .scaleAspectFill
        return imageFour
    }()
    
    lazy var profileImageFive: UIImageView = {
        let imageFive = UIImageView()
        imageFive.image = #imageLiteral(resourceName: "youcef")
        imageFive.contentMode = .scaleAspectFill
        return imageFive
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupViews()
        self.edgesForExtendedLayout = []

    }
    
    /**
     Setup views constraints
    */
    func setupViews() {
        self.view.addSubview(photosView)
        self.view.addSubview(profileDescriptionView)
        photosView.addSubview(mainStackView)
        photosView.addSubview(horizontalPhotosStackView)
        mainStackView.addArrangedSubview(mainProfileImageView)
        mainStackView.addArrangedSubview(verticalPhotosStackView)
        verticalPhotosStackView.addArrangedSubview(profileImageOne)
        verticalPhotosStackView.addArrangedSubview(profileImageTwo)
        horizontalPhotosStackView.addArrangedSubview(profileImageThree)
        horizontalPhotosStackView.addArrangedSubview(profileImageFour)
        horizontalPhotosStackView.addArrangedSubview(profileImageFive)
        mainProfileImageView.layer.cornerRadius = mainProfileImageView.frame.width / 2
        mainProfileImageView.layer.masksToBounds = true
        mainProfileImageView.clipsToBounds = false

        // view that holds photos constraint
        photosView.setConstraints(top: self.view.topAnchor, bottom: profileDescriptionView.topAnchor, trailing: self.view.trailingAnchor, leading: self.view.leadingAnchor, constant: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: self.view.frame.width, height: self.view.frame.height / 2))
        // profile description section constraints
        profileDescriptionView.setConstraints(top: photosView.bottomAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor, leading: self.view.leadingAnchor, constant: .init(top: 0, left: 0, bottom: 0, right: 0) , size: .init(width: self.view.frame.width, height: self.view.frame.height / 2))
        // stack views constraints
        mainStackView.setConstraints(top: photosView.topAnchor, bottom: horizontalPhotosStackView.topAnchor, trailing: photosView.trailingAnchor, leading: photosView.leadingAnchor, constant: .init(top: 0, left: 11, bottom: 0, right: -11))
     //   verticalPhotosStackView.setConstraints(top: photosView.topAnchor, bottom: photosView.bottomAnchor, trailing: photosView.trailingAnchor, leading: mainProfileImageView.trailingAnchor, constant: .init(top: 4, left: 4, bottom: 4, right: 4), size: .init(width: mainStackView.frame.width, height: 50))
        
        horizontalPhotosStackView.setConstraints(top: mainStackView.bottomAnchor, bottom: photosView.bottomAnchor, trailing: photosView.trailingAnchor, leading: mainStackView.leadingAnchor, constant: .init(top: 1, left: 1, bottom: -1, right: -1))
     //   mainProfileImageView.setConstraints(top: photosView.topAnchor, bottom: horizontalPhotosStackView.topAnchor, trailing: verticalPhotosStackView.leadingAnchor, leading: photosView.leadingAnchor, constant: .init(top: 4, left: 4, bottom: 4, right: 4), size: .init(width: 50, height: 50))
        
        
        profileImageOne.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageOne.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        profileImageTwo.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageTwo.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        profileImageThree.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageThree.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        profileImageFour.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageFour.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        profileImageFive.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageFive.widthAnchor.constraint(equalToConstant: 100).isActive = true
      //  verticalPhotosStackView.widthAnchor.constraint(equalToConstant: mainStackView.frame.width / 2).isActive = true
       
        
    }
}
