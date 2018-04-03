//
//  CompleteProfileViewController.swift
//  ChatHomie
//
//  Created by youcef bouhafna on 10/11/17.
//  Copyright © 2017 Youcef. All rights reserved.
//

import UIKit

class CompleteProfileViewController: UIViewController, UINavigationBarDelegate, UINavigationControllerDelegate {
    var StatesList = [String]()
    var imagePicker = UIImagePickerController()
    var profilePhotoHeight: NSLayoutConstraint?
    var statesPickerHeight: NSLayoutConstraint?
    var profile: LoginViewController?
    
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
    var statesPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .clear
        pickerView.layer.cornerRadius = 6
        pickerView.layer.borderWidth = 2
        pickerView.layer.borderColor = UIColor.lightGray.cgColor
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    var profileImage: UIImageView = {
        var sampleImage = UIImageView()
        sampleImage.image = UIImage(named: "uploadPhoto")
        sampleImage.translatesAutoresizingMaskIntoConstraints = false
        
        return sampleImage
    }()
    
    var uploadPhotoStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    var pickerViewStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.distribution = .fill
        return stackView
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
    
    var choosePhotoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Upload Photo"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .blue
        
        return label
    }()
    
    var selectState: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select Your State"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .blue
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        statesPickerView.delegate = self
        statesPickerView.dataSource = self
        setupViews()
        loadStatesFromPlist()
        profileImage.tintColor = .red
        
    }
    
    func setupViews() {
        view.addSubview(stackViewContainer)
        
        stackViewContainer.addArrangedSubview(uploadPhotoStackView)
        stackViewContainer.addArrangedSubview(pickerViewStackView)

        uploadPhotoStackView.addArrangedSubview(choosePhotoLabel)
        uploadPhotoStackView.addArrangedSubview(profileImage)
        pickerViewStackView.addArrangedSubview(selectState)
        pickerViewStackView.addArrangedSubview(statesPickerView)
        stackViewContainer.addArrangedSubview(EnterButton)
        EnterButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        EnterButton.widthAnchor.constraint(equalTo: stackViewContainer.widthAnchor, constant: -8).isActive = true
        // profile image
        profileImage.widthAnchor.constraint(equalToConstant: 57).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        // stackView
        stackViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        stackViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        stackViewContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        stackViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        
        // picker view
        statesPickerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        // labels
        choosePhotoLabel.widthAnchor.constraint(equalTo: stackViewContainer.widthAnchor).isActive = true
        choosePhotoLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        selectState.heightAnchor.constraint(equalToConstant: 35).isActive = true
        selectState.widthAnchor.constraint(equalTo: choosePhotoLabel.widthAnchor).isActive = true
        
    }
    
    /// image picker button tapped
    func addPhotoTapped() {
        /**
         - in function
         - click on picture icon to load imagePicker to choose picture from camera or gallery
         - create picker for age, state
         - create button called Enter.
         
         /// Enter button logic:
         - onClick will segue users list
         - Save Data to Firebase under the current user node
         
         */
    }
    
    /// Enter Button Action Function to call in button target
    func enterButtonTapped() {
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


