//
//  MessageInputContainer.swift
//  ChatHomie
//
//  Created by youcef bouhafna on 10/23/17.
//  Copyright © 2017 Youcef. All rights reserved.
//

import UIKit

class MessageInputContainer: UIView, UITextFieldDelegate {
    
    weak var chatControllerDelegate: ChatViewController? {
        didSet {
            if !(inputTextField.text?.isEmpty)! {
                sendButton.addTarget(chatControllerDelegate, action: #selector(ChatViewController.handleSendingMessage), for: .touchUpInside)
            }
        }
    }
    //
    //            //            AddImage.addGestureRecognizer(UITapGestureRecognizer(target: chatControllerDelegate, action: #selector(chatControllerDelegate.AddImage)))
    //        }
    
    /**
     UI Components
     */
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
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
    
    let sendButton = UIButton(type: .system)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
        addSubview(uploadImageView)
        //x,y,w,h
        uploadImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        sendButton.setTitle("Send", for: UIControlState())
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.isUserInteractionEnabled = true
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
        
        //        let separatorLineView = UIView()
        //        separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        //        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        //        addSubview(separatorLineView)
        //x,y,w,h
        //        separatorLineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        //        separatorLineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        //        separatorLineView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        //        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    
    ///UITextField delegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.isEmpty)! {
            textField.isEnabled = false
            textField.endEditing(true)
        } else {
            textField.isEnabled = true
            textField.becomeFirstResponder()
            textField.placeholder = ""
            chatControllerDelegate?.handleSendingMessage()
        }
        
        return true
    }
    
}

