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
import FOView

class LoginViewController: UIViewController, UIScrollViewDelegate {
    let ref = Database.database().reference()
    var currentUserID: String?
    var currentUser: User?
    var timer: Timer?
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    var walkThroughImages:[UIImage] = [#imageLiteral(resourceName: "walkThrough01"), #imageLiteral(resourceName: "walkThrough02"), #imageLiteral(resourceName: "youcef")]
    
    var pageController = UIPageViewController()
    var pages = [UIView]()
    let pageControl = UIPageControl()
    
    let scrollView = UIScrollView()
    /// Profile Image
    var profileImage = UIImageView ()
    
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
        button.addTarget(self, action: #selector(loginWithFacebook), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        view.backgroundColor = .white
        setupViewsConstraints()
        configurePageControl()
        configureScrollView()
        
    }
    
    /**
     Page controle configuration and constraints
     */
    func configurePageControl() {
        // pageControl
        pageControl.frame = CGRect()
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.numberOfPages = self.walkThroughImages.count
        self.view.addSubview(self.pageControl)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.bottomAnchor.constraint(equalTo: self.facebookLoginButton.topAnchor, constant: -50).isActive = true
        pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        //
    }
    
    /**
     ScrollView configuration
     */
    func configureScrollView() {
        scrollView.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height)
        for index in 0..<walkThroughImages.count {
            var mainWalkThroughImageContainer = UIImageView()
            mainWalkThroughImageContainer.frame = CGRect(x: self.view.frame.size.width * CGFloat(index), y: 0, width: self.view.frame.width, height: self.view.frame.height)
            mainWalkThroughImageContainer.contentMode = .scaleAspectFit
            self.scrollView.isPagingEnabled = true
            self.scrollView.bounces = false
            self.scrollView.showsHorizontalScrollIndicator = false
            self.scrollView.showsVerticalScrollIndicator = false
            mainWalkThroughImageContainer.image = self.walkThroughImages[index]
            self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * CGFloat((self.walkThroughImages.count)), height: self.scrollView.frame.size.height)
            self.scrollView.addSubview(mainWalkThroughImageContainer)
            
        }
        
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(changePage(sender:)), userInfo: nil, repeats: true)
    }
    
    /**
     Changes the pages when scrolling takes efffect
     */
    @objc func changePage(sender: AnyObject) {
        var x = self.scrollView.contentOffset.x
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveLinear, animations: {
            self.scrollView.scrollRectToVisible(CGRect(x: self.scrollView.frame.width + x, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height), animated: true)
        }) { (complete) in
            print("***ScrollView just completed animated***")
        }
        
    }
    
    // Mark: - ScrollView Delegate Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = round((scrollView.contentOffset.x) / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    /**
     Views Constraints Configuration
     */
    func setupViewsConstraints() {
        view.addSubview(facebookLoginButton)
        facebookLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        facebookLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        facebookLoginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        facebookLoginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
    }
    
    /**
     Handles showing the list of users
     */
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
    
    
    /**
     Performs authenticatino via Facebook
     - Parameter sender: UIButton as a sender
     */
    @objc func loginWithFacebook(sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(readPermissions: [.publicProfile], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.getFBUserData()
            }
        }
    }
    
    /// Fetches user data from facebook
    func getFBUserData() {
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
                        
                        if let imageURL = ((data["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                            //Download image from imageURL
                            self.profileImage.image = UIImage(data: try! Data(contentsOf: URL(string: imageURL)!))
                            
                        }
                        
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




