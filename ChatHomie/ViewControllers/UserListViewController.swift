//
//  UserListViewController.swift
//  ChatHomie
//
//  Created by youcef bouhafna on 9/18/17.
//  Copyright © 2017 Youcef. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
class UserListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    var users: LoginViewController?
    var chatVC =  ChatViewController()
    var usersList = [User]()
    var user: User?
    let cellId = "cellId"
    var collectionView: UICollectionView!
    var flowLayout = UICollectionViewFlowLayout()
    var messageId: Message?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        collectionView?.register(UserCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        flowLayout.minimumInteritemSpacing = 1
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView?.alwaysBounceVertical = true
        self.view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.invalidateIntrinsicContentSize()
        observeUsers()

        
    }
    
    func observeUsers() {
        // reference firebase users database
        
        let ref =  Database.database().reference().child("Users")
        // observe users database
        ref.observe(.childAdded, with: { (snapshot) in
            // get the json object value as an array of  dictionaries
            if let jsonDictionary = snapshot.value as? [String: AnyObject] {
                let user = User(withDictionary: jsonDictionary)
                user.id = snapshot.key
                if user.id != Auth.auth().currentUser?.uid {
                    self.usersList.append(user)
                    DispatchQueue.main.async(execute: {
                        self.collectionView?.reloadData()
                    })
                }
            }
            
        }, withCancel: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usersList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserCell
        let user = usersList[indexPath.item]
        cell.cellUserName.text = user.userName
        if let profileImage = user.profileImageUrl {
            cell.profileImage.loadImageUsingCacheWithUrlString(profileImage)
        } else {
            //       cell.profileImage.image =
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: view.frame.width, height: 100)
        return cellSize
    }
    
    /// function to click on user and open chat. segue to ConversationViewController
    var conversationsController: ConversationsViewController?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = usersList[indexPath.item]
        guard let id = user.id else {return }
        let ref = Database.database().reference().child("Users").child(id)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            guard let jsonDictionary = snapshot.value as? NSDictionary else {return}
            let user = User(withDictionary: jsonDictionary as! [String : Any])
            user.id = id
            self.showChatVC(user: user)
            
        }, withCancel: nil)
        
    }
    
    func getUserID() {
        
    }
    func showChatVC(user: User) {
        
        let chatLogController = ChatViewController()
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
        
    }
    
}
