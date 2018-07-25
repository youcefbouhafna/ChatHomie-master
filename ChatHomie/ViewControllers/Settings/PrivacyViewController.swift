//
//  PrivacyViewController.swift
//  ChatHomie
//
//  Created by Youcef Bouhafna on 5/18/18.
//  Copyright © 2018 Youcef. All rights reserved.
//

import UIKit

class PrivacyViewController: UIViewController, UITextViewDelegate {
    
    var privacyPolicyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Privacy Policy"
        label.textAlignment = .center
        return label
    }()
    
    var privacyPolicyTextView: UITextView = {
        let textView = UITextView()
        textView.allowsEditingTextAttributes = false
        textView.textColor = .black
        textView.isEditable = false
        textView.font = UIFont.boldSystemFont(ofSize: 15)
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 4
        textView.text = "To protect your website, company, and customers, you need to state your terms of use in clear, simple, and easily-understood language. Our simple terms and conditions template can instantly generate a custom terms of service policy for your business.To protect your website, company, and customers, you need to state your terms of use in clear, simple, and easily-understood language. Our simple terms and conditions template can instantly generate a custom terms of service policy for your businessTo protect your website, company, and customers, you need to state your terms of use in clear, simple, and easily-understood language. Our simple terms and conditions template can instantly generate a custom terms of service policy for your business"
        return textView
    }()
    
    var privacyPolicyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.view.backgroundColor = .white
    }
    
    /**
     setup views
    */
    func setupViews() {
        self.view.addSubview(privacyPolicyStackView)
        privacyPolicyStackView.addArrangedSubview(privacyPolicyLabel)
        privacyPolicyStackView.addArrangedSubview(privacyPolicyTextView)
        
        privacyPolicyStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        privacyPolicyStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        privacyPolicyStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        privacyPolicyStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true

        privacyPolicyLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        privacyPolicyLabel.widthAnchor.constraint(equalTo: privacyPolicyStackView.widthAnchor, constant: -8).isActive = true
        privacyPolicyTextView.heightAnchor.constraint(equalTo: privacyPolicyTextView.heightAnchor, constant: -50).isActive = true
        privacyPolicyTextView.widthAnchor.constraint(equalTo: privacyPolicyStackView.widthAnchor, constant: -8).isActive = true

        
        
    }

}
