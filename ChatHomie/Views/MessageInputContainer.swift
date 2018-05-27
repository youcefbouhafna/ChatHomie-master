//
//  MessageInputContainer.swift
//  ChatHomie
//
//  Created by youcef bouhafna on 10/23/17.
//  Copyright © 2017 Youcef. All rights reserved.
//

import UIKit

class MessageInputContainer: UIView, UITextFieldDelegate {
    
    var chatVC: ChatViewController?
    weak var delegate: SendingMessageDelegate?
    //
    //            //            AddImage.addGestureRecognizer(UITapGestureRecognizer(target: chatControllerDelegate, action: #selector(chatControllerDelegate.AddImage)))
    //        }
    
    /**
     UI Components
     */
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    let uploadImageView: UIImageView = {
        let uploadImageView = UIImageView()
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.image = UIImage(named: "upload_image_icon")
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        return uploadImageView
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(sendMessageOnButtonClick(sender:)), for: .touchUpInside)
        return button
    }()
    
    
    @objc func sendMessageOnButtonClick(sender: UIButton) {
        if (inputTextField.text?.isEmpty)! {
            inputTextField.isEnabled = false
            inputTextField.endEditing(true)
        } else {
            inputTextField.isEnabled = true
            inputTextField.becomeFirstResponder()
            inputTextField.placeholder = "Enter Message..."
            delegate?.sendMessage(chatController: chatVC!)
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
        addSubview(uploadImageView)
        //x,y,w,h
        uploadImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        
        self.addSubview(sendButton)
        //x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(self.inputTextField)
        //x,y,w,h
        self.inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    
    ///UITextField delegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.isEmpty)! {
            textField.isEnabled = false
            textField.endEditing(true)
        } else {
            textField.isEnabled = true
            textField.becomeFirstResponder()
            textField.placeholder = "Enter Message..."
            delegate?.sendMessage(chatController: chatVC!)
            
        }
        
        return true
    }
    
}

protocol SendingMessageDelegate: class {
    func sendMessage(chatController: ChatViewController)
}

extension SendingMessageDelegate {
    func sendMessage(chatController: ChatViewController) {
        chatController.handleSendingMessage()
    }
}
