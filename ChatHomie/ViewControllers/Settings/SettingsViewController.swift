//
//  SettingsViewController.swift
//  ChatHomie
//
//  Created by Youcef Bouhafna on 4/10/18.
//  Copyright © 2018 Youcef. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
/**
 Settings class to manage all app settings
 */
class SettingsViewController: UIViewController {
    
    var settingsList: [SettingsItems] = [.profileImages, .biometrics, .reviewApp, .notification, .privacyPolicy, .donate, .signOut]
    var settingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        self.view.addSubview(settingsTableView)
        settingsTableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "cellID")
        self.view.backgroundColor = .white
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        
    }
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Settings"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsTableView.reloadData()
        
    }
    
    ///Show logout alert and logout if user clicks on logout button
    @objc func showLogoutAlert() {
        let alert = UIAlertController(title: "Logout", message: "Are You Sure You want To Logout?", preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout", style: .default) { (action) in
            if let currentUserID = Auth.auth().currentUser?.uid {
                DispatchQueue.main.async {
                    FirebaseController.status(uid: currentUserID)
                    try! Auth.auth().signOut()
                    loginManager.logOut()
                    let loginViewController = LoginViewController()
                    self.present(loginViewController, animated: true, completion: nil)
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.addAction(logoutAction)
        present(alert, animated: true, completion: nil)
        
    }
    
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! SettingsTableViewCell
        let setting = settingsList[indexPath.row]
        cell.configWith(setting: setting)
        cell.setupViews()
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let settingItem = settingsList[indexPath.row]
        switch settingItem {
        case .notification: performSegue(withIdentifier: "notificationSegue", sender: nil)
        case .biometrics: performSegue(withIdentifier: "biometricsSegue", sender: nil)
        case .donate: Navigator.showDonateVC(onParentVC: self, withStyle: .stack, animated: true)
        case .privacyPolicy: Navigator.showPrivacyPolicy(onParentVC: self, withStyle: .stack, animated: true)
        case .profileImages: Navigator.showProfile(onParentVC: self, withStyle: .stack, animated: true)
        case .signOut: showLogoutAlert()
        case .reviewApp: performSegue(withIdentifier: "reviewAppSegue", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
