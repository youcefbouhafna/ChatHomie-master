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
        view.backgroundColor = .red
        return view
    }()
    
    lazy var verticalPhotosStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy var horizontalPhotosStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
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
        profileImage.contentMode = .scaleAspectFit
        return profileImage
    }()
    
    lazy var profileImageOne: UIImageView = {
        let imageOne = UIImageView()
        imageOne.backgroundColor = .blue
        return imageOne
    }()
    
    lazy var profileImageTwo: UIImageView = {
        let imageTwo = UIImageView()
        imageTwo.backgroundColor = .brown
        return imageTwo
    }()
    
    lazy var profileImageThree: UIImageView = {
        let imageThree = UIImageView()
        imageThree.backgroundColor = .black
        return imageThree
    }()
    lazy var profileImageFour: UIImageView = {
        let imageFour = UIImageView()
        imageFour.backgroundColor = .cyan
        return imageFour
    }()
    
    lazy var profileImageFive: UIImageView = {
        let imageFive = UIImageView()
        imageFive.backgroundColor = .purple
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
        photosView.addSubview(verticalPhotosStackView)
        photosView.addSubview(horizontalPhotosStackView)
        photosView.addSubview(mainProfileImageView)
        verticalPhotosStackView.addArrangedSubview(profileImageOne)
        verticalPhotosStackView.addArrangedSubview(profileImageTwo)
        verticalPhotosStackView.addArrangedSubview(profileImageThree)
        horizontalPhotosStackView.addArrangedSubview(profileImageFour)
        horizontalPhotosStackView.addArrangedSubview(profileImageFive)
        
        // view that holds photos constraint
        photosView.setConstraints(top: self.view.topAnchor, bottom: profileDescriptionView.topAnchor, trailing: self.view.trailingAnchor, leading: self.view.leadingAnchor, constant: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: self.view.frame.width, height: self.view.frame.height / 2))
        // profile description section constraints
        profileDescriptionView.setConstraints(top: photosView.bottomAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor, leading: self.view.leadingAnchor, constant: .init(top: 0, left: 0, bottom: 0, right: 0) , size: .init(width: self.view.frame.width, height: self.view.frame.height / 2))
        // stack views constraints
        verticalPhotosStackView.setConstraints(top: photosView.topAnchor, bottom: photosView.bottomAnchor, trailing: photosView.trailingAnchor, leading: mainProfileImageView.trailingAnchor, constant: .init(top: 4, left: 4, bottom: 4, right: 4), size: .init(width: 50, height: 50))
        horizontalPhotosStackView.setConstraints(top: mainProfileImageView.bottomAnchor, bottom: photosView.bottomAnchor, trailing: verticalPhotosStackView.leadingAnchor, leading: photosView.leadingAnchor, constant: .init(top: 4, left: 4, bottom: 4, right: 4), size: .init(width: 50, height: 50))
        mainProfileImageView.setConstraints(top: photosView.topAnchor, bottom: horizontalPhotosStackView.topAnchor, trailing: verticalPhotosStackView.leadingAnchor, leading: photosView.leadingAnchor, constant: .init(top: 4, left: 4, bottom: 4, right: 4), size: .init(width: 50, height: 50))
        
    }
}
