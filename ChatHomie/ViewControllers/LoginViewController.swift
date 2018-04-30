//
//  ViewController.swift
//  ChatHomie
//
//  Created by youcef bouhafna on 7/20/17.
//  Copyright © 2017 Youcef. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import Foundation
import SwiftMessages
import SVProgressHUD
import FBSDKLoginKit
import FacebookLogin

class LoginViewController: UIViewController, UITextFieldDelegate {
    let ref = Database.database().reference()
    var currentUserID: String?
    var currentUser: User?
    var inputContainerHeight: NSLayoutConstraint?
    var userNameHeightAnchor: NSLayoutConstraint?
    var emailHeightAnchor: NSLayoutConstraint?
    var passwordHeightAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.backgroundColor = UIColor(red: 0.404, green: 0.627, blue: 0.2327, alpha: 1.00)
        view.addBackGroundImageBlurEffect()
        setupViewsConstraints()
      //  addDevAccounts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    ///add test account navigation bar button item
    func addDevAccounts() {
        addNavigationBarButtons()
    }
    
    /// blurview
    var blurView: UIBlurEffect = {
        let blur = UIBlurEffect()
        return blur
    }()
    
    /// Walkthrough View for the UIPageControlVC
    var walkThroughtContainerView: UIView = {
        var containerView = UIView()
        containerView.backgroundColor = .red
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    /// Facebook Button at login view
    var facebookLoginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 0.008 ,green: 0.533 ,blue: 0.820 ,alpha: 1.00)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.setTitle("Facebook Login", for: UIControlState())
        button.setTitleColor(.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(facebookLoginButtonClicked), for: .touchUpInside)
        
        return button
    }()
    
    /// Profile Image
    var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageView.frame.size.height / 2
        imageView.clipsToBounds = true
        
        imageView.isUserInteractionEnabled = true
        //  imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageAction)))
        return imageView
    }()
    
    func setupViewsConstraints() {
        view.addSubview(walkThroughtContainerView)
        view.addSubview(facebookLoginButton)
        
        walkThroughtContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        walkThroughtContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        walkThroughtContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        walkThroughtContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        walkThroughtContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        walkThroughtContainerView.bottomAnchor.constraint(equalTo: facebookLoginButton.topAnchor, constant: 10).isActive = true
        
        
        facebookLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        facebookLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        facebookLoginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        facebookLoginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        
    }
    /// Handles settting up profile image layout constraints
    func setupProfileImage() {
        // profile image constraints
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
      //  profileImage.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -15).isActive = true
    }
 
    
    /// Handles showing the list of users
    func showUserList() {
        let userListController = UserListViewController()
        userListController.users = self
        navigationController?.pushViewController(userListController, animated: true)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.makeKeyAndVisible()
        appDelegate.window?.rootViewController = UINavigationController(rootViewController: MainTabBarController())
        
        
    }
    
    /// Handles showing the complete your profile page
    func showCompleteProfile() {
        
        let completeProfileController = CompleteProfileViewController()
        completeProfileController.profile = self
        completeProfileController.userID = currentUserID
        self.navigationController?.pushViewController(completeProfileController, animated: true)
    }
    
    /// Login button action
    @objc func facebookLoginButtonClicked(sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(readPermissions: [.publicProfile], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                SVProgressHUD.show(withStatus: "Signing...")
                
                
                Auth.auth().signIn(with: credential) { (user, error) in
                    SVProgressHUD.dismiss()
                    if error != nil {
                        print(error.debugDescription)
                    }
                    
                    guard let uid = user?.uid else {
                        return
                    }
                    ///////
                    if((FBSDKAccessToken.current()) != nil) {
                        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                            if (error == nil) {
                                let data = result as! NSDictionary
                                print(result!)
                                print(data)
                                
                                // Facebook users name:
                                let userName: String = data.object(forKey: "name") as! String
                                print("User Name is: \(userName)")
                                
                                let fbProfileImage = data.object(forKey: "picture") as! String
                                self.profileImage.image = UIImage(contentsOfFile: fbProfileImage)
                                // Facebook users email:
//                                let userEmail: String = data.object(forKey:"email") as! String
//                                print("User Email is: \(userEmail)")
                                
                                // Facebook users ID:
                                let userID: String = data.object(forKey:"id") as! String
                                print("Users Facebook ID is: \(userID)")
                                
                                let imageName = UUID().uuidString
                                let storageRef = Storage.storage().reference().child("profile_images").child(imageName)
                                
                                if let profileImage = self.profileImage.image,
                                    let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                                    storageRef.putData(uploadData, metadata: nil, completion: { (metaData, error) in
                                        if error != nil {
                                            
                                            print(error as Any)
                                            
                                            return
                                        }
                                        
                                        if let profileImageUrl = metaData?.downloadURL()?.absoluteString {
                                            let values = ["userName": userName, "profileImageUrl": profileImageUrl]
                                            let usersEndPoint = self.ref.child("Users").child(uid)
                                            usersEndPoint.updateChildValues(values, withCompletionBlock: { (error, ref) in
                                                if error != nil {
                                                    print(error as Any)
                                                    let view = MessageView.viewFromNib(layout: .messageView)
                                                    view.configureTheme(.error)
                                                    view.configureDropShadow()
                                                    view.configureContent(body: "There were a problem logging in. Please try again")
                                                    SwiftMessages.show(view: view)
                                                    return
                                                }
                                                
                                                let view = MessageView.viewFromNib(layout: .messageView)
                                                view.configureTheme(.success)
                                                view.configureDropShadow()
                                                view.configureContent(title: "Login Success", body: "")
                                                SwiftMessages.show(view: view)
                                                
                                                let when = DispatchTime.now()
                                                DispatchQueue.main.asyncAfter(deadline: when + 2) {
                                                    self.showUserList()
                                                    self.currentUserID = user?.uid
                                                }
                                            })
                                        }
                                    })
                                    
                                }
                            }
                        })
                    }
                    
                }
            }
        }
    }
    
    /// Fetches user data from facebook
    func getFBUserData() {
        
    }
}


//TODO:-
/**
 when user click on Login it will segue to usersList.
 when user click on register it will take them to CompleteProfileVC to submit a picture, age and state.
 
 */





