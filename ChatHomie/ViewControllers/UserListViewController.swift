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

class UserListViewController: UIViewController {
    var users: LoginViewController?
    var chatVC =  ChatViewController()
    var conversationsController: ConversationsViewController?
    var usersList = [User]()
    var user: User?
    let cellId = "cellId"
    var collectionView: UICollectionView!
    var flowLayout = UICollectionViewFlowLayout()
    var messageId: Message?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Users"
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
        AddNavigationItems()
        observeUsers()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    
    
    /// Setup Tabbar items
    func setupTabBarItem() {
        let usersListVC = UserListViewController()
        tabBarController?.tabBar.items?[0].title = "Users"
        let conversationsVC = ConversationsViewController()
        tabBarController?.tabBar.items?[1].title = "Conversations"
        let settingsVC = SettingsViewController()
        tabBarController?.tabBar.items?[2].title = "Settings"
        let viewControllerList = [ usersListVC, conversationsVC, settingsVC ]
        tabBarController?.setViewControllers(viewControllerList, animated: true)
        
    }
    
    ///Add Navigation bar button Items
    func AddNavigationItems() {
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(showLogoutAlert))
        self.navigationController?.navigationBar.topItem?.setRightBarButton(logoutButton, animated: true)
    }
    
    ///Show logout alert and logout if user clicks on logout button
    @objc func showLogoutAlert() {
        let alert = UIAlertController(title: "Logout", message: "Are You Sure You want To Logout?", preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout", style: .default) { (action) in
            try! Auth.auth().signOut()
            let loginViewController = LoginViewController()
            self.present(loginViewController, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.addAction(logoutAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    ///observe all users and show them on the list
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
    
    /**
     Shows the chatViewController
     - Parameter user: User to pass
     */
    func showChatVC(user: User) {
        let chatLogController = ChatViewController()
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
        
    }
    
}

//Mark: - UICollectionView DataSource and Delegates
extension UserListViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout  {
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
        cell.profileImage.loadImageUsingCacheWithUrlString(user.profileImageUrl)
       
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = usersList[indexPath.item]
        let id = user.id 
        let ref = Database.database().reference().child("Users").child(id)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            guard let jsonDictionary = snapshot.value as? NSDictionary else {return}
            let user = User(withDictionary: jsonDictionary as! [String : Any])
            user.id = id
            self.showChatVC(user: user)
            
        }, withCancel: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: view.frame.width, height: 100)
        return cellSize
    }
}
