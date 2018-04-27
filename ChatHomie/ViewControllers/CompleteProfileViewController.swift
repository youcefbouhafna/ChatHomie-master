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
    
    /**
     View that holds the profile image
 */
    
    var profileImage: UIImageView = {
        var sampleImage = UIImageView()
        sampleImage.image = UIImage(named: "uploadPhoto")
        sampleImage.translatesAutoresizingMaskIntoConstraints = false
        return sampleImage
    }()
    
    var EnterButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = true
        button.layer.borderColor = UIColor.gray.cgColor
        button.setTitle("Enter", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 6
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.addTarget(self, action: #selector(enterButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        loadStatesFromPlist()
        profileImage.tintColor = .red
        chooseProfilePicGesture()
        
    }
    
    func setupViews() {
        view.addSubview(stackViewContainer)
        
        // profile image
        profileImage.widthAnchor.constraint(equalToConstant: 57).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        // stackView
        stackViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        stackViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        stackViewContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        stackViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        
    }
    
    /// Enter Button Action Function to call in button target
    @objc func enterButtonTapped() {
        /**
         - hit enter button
         - ToDo: build the second pickerView column of age and third column of gender
         - grab the selected photo by user and selected state and age and gender
         - save the data under the user in firebase
         - segue to list of users sorted by the same state as the user selected state from pickerView
         
         
         */
    }
    /// load plist states array
    func loadStatesFromPlist() {
        var statesArray: [String] = []
        if let url = Bundle.main.url(forResource:"StatesDataSource", withExtension: "plist") {
            do {
                let data = try Data(contentsOf:url)
                let statesDictionary = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String:Any]
                // do something with the dictionary
                for state in statesDictionary.values {
                    statesArray.append(state as! String)
                    self.StatesList = statesArray
                    //TODO:- Find a way to sort the array so Arizona is on top 
                }
            } catch {
                print(error)
            }
        }
    }
    
    func presentImagePicker(sourceType: UIImagePickerControllerSourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            let message = MessageView.errorMessageView(withTitle: "Error", body: "Source Type not available")
            SwiftMessages.show(view: message)
            return
        }
        
        guard let availableMedia = UIImagePickerController.availableMediaTypes(for: sourceType),
            availableMedia.contains("public.image") else {
                let message = MessageView.errorMessageView(withTitle: "No Available Images", body: "There are no images available from that source")
                SwiftMessages.show(view: message)
                return
        }
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }

    
    /// set the uplodPhoto icon to the profile image selected
}
extension CompleteProfileViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //TODO: - build 3 components
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //TODO: - load all 3 arrays
        return self.StatesList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //TODO:- return titles for all 3 columns data source 
        return StatesList[row]
    }
    
}


