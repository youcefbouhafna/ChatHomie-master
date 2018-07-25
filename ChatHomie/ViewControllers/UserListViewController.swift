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
import ViewAnimator

class UserListViewController: UIViewController {
    var ref: DatabaseQuery!
    var users: LoginViewController?
    var chatVC =  ChatViewController()
    var conversationsController: ConversationsViewController?
    var usersList = [User]()
    var user: User?
    let cellId = "cellId"
    var collectionView: UICollectionView!
    var flowLayout = UICollectionViewFlowLayout()
    var messageId: Message?
    var timer: Timer?
    var isAllUsers: Bool = false
    
    var usersSegmentedControl: UISegmentedControl = {
        let items = ["Online", "All"]
        let segControl = UISegmentedControl(items: items)
        segControl.selectedSegmentIndex = 0
        segControl.tintColor = .red
        segControl.translatesAutoresizingMaskIntoConstraints = false
        segControl.addTarget(self, action: #selector(ChangeSegmentedControlValue), for: .valueChanged)
        return segControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Users"
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        setSegmentedControlUI()
        AddNavigationItems()
        setCollectionViewUIConstraints()
        //observeUsers()
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(observeUsers), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
   @objc func ChangeSegmentedControlValue() {
        showUsersList()
    }
    /// Set segmentedControl constraints
    func setSegmentedControlUI() {
        self.view.addSubview(usersSegmentedControl)
        if #available(iOS 11.0, *) {
            usersSegmentedControl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        } else {
            // Fallback on earlier versions
        }
        usersSegmentedControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0).isActive = true
        usersSegmentedControl.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }

    func setCollectionViewUIConstraints() {
        self.view.addSubview(collectionView)
        collectionView?.register(UserCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        flowLayout.minimumInteritemSpacing = 1
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView?.alwaysBounceVertical = true
        
        collectionView.backgroundColor = .white
        collectionView.invalidateIntrinsicContentSize()
        collectionView.topAnchor.constraint(equalTo: self.usersSegmentedControl.bottomAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
    
    func showUsersList() {
        if usersSegmentedControl.selectedSegmentIndex == 0 {
            isAllUsers = false
           
        } else {
            isAllUsers = true

        }
    }
    
    ///Add Navigation bar button Items
    func AddNavigationItems() {
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(SettingsViewController.showLogoutAlert))
        logoutButton.tintColor = .blue
        self.navigationItem.setRightBarButton(logoutButton, animated: true)
    }
    
    /**
     Function to call when selecting online users
    */
    
    /**
     Function to call when selecting all users
    */
    
    ///observe all users and show them on the list
    @objc func observeUsers() {
        self.usersList = []
        // reference firebase users database
        // observe users database
        if !isAllUsers {
            ref = Database.database().reference().child("Users").queryOrdered(byChild: "isOnline").queryEqual(toValue: true)
        } else {
            ref = Database.database().reference().child("Users")
        }
        
        ref.observe(.childAdded, with: { (snapshot) in
            // get the json object value as an array of  dictionaries
            if let jsonDictionary = snapshot.value as? [String: AnyObject] {
                let user = User(withDictionary: jsonDictionary)
                user.id = snapshot.key
                user.isOnline = jsonDictionary["isOnline"] as? Bool ?? false
                if user.id != Auth.auth().currentUser?.uid {
                    self.usersList.append(user)
                    DispatchQueue.main.async(execute: {
                        self.collectionView?.reloadData()
                    })
                }
            }
        }, withCancel: { (error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 , execute: {
                self.collectionView.reloadData()
            })
        })
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
        if user.isOnline == true {
            DispatchQueue.main.async {
                cell.userConnectionStatus.textColor = .green
                cell.userConnectionStatus.text = "Online"
                collectionView.reloadData()
            }
            
        } else {
            DispatchQueue.main.async {
                cell.userConnectionStatus.textColor = .red
                cell.userConnectionStatus.text = "Away"
                collectionView.reloadData()
            }
        }
        
       
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
