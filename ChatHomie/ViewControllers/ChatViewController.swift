//
//  ChatViewController.swift
//  ChatHomie
//
//  Created by youcef bouhafna on 10/21/17.
//  Copyright © 2017 Youcef. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
class ChatViewController: UIViewController, UITextFieldDelegate {
    
    var ids = [String]()
    var conversation: ConversationsViewController?
    var textInputContainerView =  MessageInputContainer()
    var user: User? {
        didSet {
            fetchConversationsForUser()
        }
    }
    var messages = [Message]()
    var flowLayout = UICollectionViewFlowLayout()
    var collectionView:  UICollectionView!
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 50), collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        // fetchConversations()
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        //        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        collectionView.register(ChatLogCollectionViewCell.self, forCellWithReuseIdentifier: "cellID")
        textInputContainerView = UINib(nibName: "MessageInputContainerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MessageInputContainer
        textInputContainerView.chatControllerDelegate = self
        self.view.addSubview(textInputContainerView)
        self.view.addSubview(collectionView)
        hideKeyboard()
        textInputContainerView.translatesAutoresizingMaskIntoConstraints = false
        textInputContainerView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 0).isActive = true
        textInputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        textInputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        textInputContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        setupKeyboardObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    /// hide keyboard on gesture tap
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    /// dismiss keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    
    func fetchConversationsForUser() {
        guard let uid = Auth.auth().currentUser?.uid, let toId = user?.id else {
            return
        }
        
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toId)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                self.messages.append(Message(dictionary: dictionary)!)
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                    //scroll to the last index
                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                })
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    @objc func handleSendingMessage() {
        let jsonDictionary = ["Text": textInputContainerView.inputTextField.text!]
        createMessageOnSendWith(jsonDictionary as [String : AnyObject])
    }
    
    func createMessageWith(imageUrl: String, image: UIImage) {
        let messageDictionary = ["ImageUrl": imageUrl, "ImageWidth": image.size.width, "ImageHeight": image.size.height] as [String : Any]
        createMessageOnSendWith(messageDictionary as [String : AnyObject])
    }
    
    
    fileprivate func createMessageOnSendWith(_ newDictionary: [String: AnyObject]) {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id
        let fromId = Auth.auth().currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        
        var values: [String: AnyObject] = ["receiver": toId as AnyObject, "sender": fromId as AnyObject, "timestamp": timestamp as AnyObject]
        
        //append properties dictionary onto values somehow??
        //key $0, value $1
        newDictionary.forEach({values[$0] = $1})
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            self.textInputContainerView.inputTextField.text = nil
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId)
            
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId)
            recipientUserMessagesRef.updateChildValues([messageId: 1])
        }
    }
    

    
    /**
     Handles keyboard mechanism
     */
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    /// Handle Keyboard showing
    @objc func handleKeyboardDidShow() {
        if messages.count > 0 {
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
    
    ///Handles keyboard will show
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    ///Handles keyboard hiding
    @objc func handleKeyboardWillHide(_ notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    ///Toggle keyboard
//    func toggleKeyboard() {
//        textInputContainerView.inputTextField.toggleKeyboardStatus(textInputContainerView.inputTextField)
//    }
   
}

extension ChatViewController:  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! ChatLogCollectionViewCell
        cell.chatController = self
        let message = messages[indexPath.item]
        cell.message = message
        cell.textView.text = message.text
        setupCell(message: message, cell: cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = messages[indexPath.item]
        var bubbleTextMessageHeight: CGFloat = 80
        if let textMsg = message.text {
            bubbleTextMessageHeight = estimateFrameForText(textMsg).height + 30
        }
        return CGSize(width: view.frame.width, height: bubbleTextMessageHeight)
    }
    
    func setupCell(message: Message, cell: ChatLogCollectionViewCell) {
        if let profileImageUrl = self.user?.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        if message.sender == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = ChatLogCollectionViewCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        } else {
            //incoming gray
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = false
            
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
    }
    
    fileprivate func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [kCTFontAttributeName as NSAttributedStringKey: UIFont.systemFont(ofSize: 16)], context: nil)
    }
}

/**
 . User_Messages
 .fromId: lksjfsdfjklsf
 .toID:   ljkslfksfdlsfls
 
 */

enum FirebaseNodes: String {
    case Users = "Users"
    case Messages = "Messages"
    case Conversations = "Conversations"
    case UserConversations = "UserConversations"
    case conversationUsers = "ConversationUsers"
    case conversationMessages = "ConversationMessages"
    
}
