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
    var dict : [String : AnyObject]!
    
    var inputContainerHeight: NSLayoutConstraint?
    var userNameHeightAnchor: NSLayoutConstraint?
    var emailHeightAnchor: NSLayoutConstraint?
    var passwordHeightAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.backgroundColor = UIColor(red: 0.404, green: 0.627, blue: 0.2327, alpha: 1.00)
        view.addBackGroundImageBlurEffect()
        view.addSubview(facebookLoginButton)
        view.addSubview(loginChoiceLabel)
        view.addSubview(inputsContainerView)
        //view.addSubview(profileImage)
        view.addSubview(loginButton)
        view.addSubview(LoginSegmentedControl)
        setupContainerView()
        setupLoginButton()
        setupFacebookLoginButton()
        setupLoginChoiceLabel()
        setupSegmentedControl()
        let authButtonTitle = LoginSegmentedControl.titleForSegment(at: LoginSegmentedControl.selectedSegmentIndex)
        loginButton.setTitle(authButtonTitle, for: .normal)
        addDevAccounts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    ///add test account navigation bar button item
    func addDevAccounts() {
        addNavigationBarButtons()
    }
    
    //Mark: - Login or Create account action
    @IBAction func handleAuthenticationAction(sender: UIButton) {
        if (!(emailTextField.text?.isEmpty)!) || (!(passwordTextField.text?.isEmpty)!) || (!(userNameTextField.text?.isEmpty)!) {
            guard let email = emailTextField.text,
                let password = passwordTextField.text else {
                    return
            }
            
            if LoginSegmentedControl.selectedSegmentIndex == 0 {
                
                SVProgressHUD.show(withStatus: "Signing...")
                
                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                    SVProgressHUD.dismiss()
                    if error != nil {
                        let database = Database.database().reference()
                        database.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
                            if snapshot.hasChild((Auth.auth().currentUser?.uid)!) == false {
                                let view = MessageView.viewFromNib(layout: .messageView)
                                view.configureTheme(Theme.error)
                                view.configureDropShadow()
                                view.configureContent(title: "Ghost Account", body: "Verify Your Credentials Or Create A New Account To Use")
                            }
                        })
                        
                        print(error.debugDescription)
                        return
                    } else {
                        print(email + " " + password)
                        let view = MessageView.viewFromNib(layout: .messageView)
                        view.configureTheme(.success)
                        view.configureDropShadow()
                        view.configureContent(title: "Login Success", body: "")
                        SwiftMessages.show(view: view)
                        let when = DispatchTime.now()
                        DispatchQueue.main.asyncAfter(deadline: when) {
                            self.showUserList()
                        }
                        
                    }
                    
                })
                
            } else if LoginSegmentedControl.selectedSegmentIndex == 1 {
                
                guard let email = emailTextField.text,
                    let password = passwordTextField.text,
                    let userName = userNameTextField.text else {
                        return
                }
                
                SVProgressHUD.show(withStatus: "Creating Your Account...")
                
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                    SVProgressHUD.dismiss()
                    if error != nil {
                        let database = Database.database().reference()
                        database.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
                            if snapshot.hasChild((Auth.auth().currentUser?.uid)!) {
                                let view = MessageView.viewFromNib(layout: .messageView)
                                view.configureTheme(.error)
                                view.configureDropShadow()
                                view.configureContent(title: "Oops", body: "User Already Exists! Try Creating An Account With Different Credentials Or Login ")
                                DispatchQueue.main.async {
                                    SwiftMessages.show(view: view)
                                    
                                }
                                
                            }
                        })
                        print(error as Any)
                        return
                    }
                    guard let uid = user?.uid else {
                        
                        return
                    }
                    
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
                                let values = ["userName": userName, "email": email, "profileImageUrl": profileImageUrl]
                                let usersEndPoint = self.ref.child("Users").child(uid)
                                usersEndPoint.updateChildValues(values, withCompletionBlock: { (error, ref) in
                                    if error != nil {
                                        print(error as Any)
                                        let view = MessageView.viewFromNib(layout: .messageView)
                                        view.configureTheme(.error)
                                        view.configureDropShadow()
                                        view.configureContent(body: "Success Login")
                                        SwiftMessages.show(view: view)
                                        
                                        return
                                    }
                                    self.showCompleteProfile()
                                    
                                })
                                
                            }
                        })
                    }
                })
                
            }
        } else {
            return
        }
        
    }
    
    /// blurview
    var blurView: UIBlurEffect = {
        let blur = UIBlurEffect()
        return blur
    }()
    
    ///view that holds the credentials text fields
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    /// Login Button
    var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.773 ,green: 0.882 ,blue: 0.647 ,alpha: 1.00)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.setTitle("Login", for: UIControlState())
        button.setTitleColor(.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(handleAuthenticationAction(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    /// "Or" label
    var loginChoiceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "OR"
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        return label
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
        //    button.addTarget(self, action: #selector(handleFacebookLoginAction), for: .touchUpInside)
        
        return button
    }()
    
    /// username textField
    var userNameTextField: UITextField = {
        let userName = UITextField()
        userName.backgroundColor = .white
        userName.placeholder = "Username"
        userName.font = UIFont.boldSystemFont(ofSize: 18)
        userName.translatesAutoresizingMaskIntoConstraints = false
        return userName
    }()
    
    /// separator view of the username
    let userNameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// separate view of the email
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Email textField
    var emailTextField: UITextField = {
        let email = UITextField()
        email.backgroundColor = .white
        email.placeholder = "Email"
        email.font = UIFont.boldSystemFont(ofSize: 18)
        
        email.translatesAutoresizingMaskIntoConstraints = false
        return email
    }()
    
    /// PasswordTextField
    var passwordTextField: UITextField = {
        let password = UITextField()
        password.placeholder = "Password"
        password.font = UIFont.boldSystemFont(ofSize: 18)
        password.isSecureTextEntry = true
        password.translatesAutoresizingMaskIntoConstraints = false
        return password
    }()
    
    /// Profile Image
    var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "youcef")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageView.frame.size.height / 2
        imageView.clipsToBounds = true
        
        imageView.isUserInteractionEnabled = true
        //  imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageAction)))
        return imageView
    }()
    
    /// SegmentedControl to switch between Login and Account Creation
    var LoginSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.selectedSegmentIndex = 0
        sc.tintColor = .white
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.addTarget(self, action: #selector(handleLoginOrRegisterButtonTitle), for: .valueChanged)
        
        return sc
    }()
    
    /// Handles showing the views based on whether we are in login or account registration
    @objc func handleLoginOrRegisterButtonTitle() {
        let authButtonTitle = LoginSegmentedControl.titleForSegment(at: LoginSegmentedControl.selectedSegmentIndex)
        loginButton.setTitle(authButtonTitle, for: .normal)
        
        inputContainerHeight?.isActive = false
        inputContainerHeight = inputsContainerView.heightAnchor.constraint(equalToConstant: LoginSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150)
        inputContainerHeight?.isActive = true
        
        // change usernameTextfield height and hide it when it's only login
        userNameHeightAnchor?.isActive = false
        userNameHeightAnchor = userNameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: LoginSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        userNameHeightAnchor?.isActive = true
        userNameTextField.isHidden = LoginSegmentedControl.selectedSegmentIndex == 0
        
        // change passwordTextField height based on login or register
        passwordHeightAnchor?.isActive = false
        passwordHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: LoginSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordHeightAnchor?.isActive = true
        
        // change emailTextField height based on login or register
        emailHeightAnchor?.isActive = false
        emailHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: LoginSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailHeightAnchor?.isActive = true
    }
    
    /// Handles setting up the segmented control layout
    func setupSegmentedControl() {
        LoginSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        LoginSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -20).isActive = true
        LoginSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        LoginSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    /// Setup credentials textfiels views layout
    func setupContainerView() {
        // setup blur view
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        inputsContainerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        inputsContainerView.addSubview(userNameTextField)
        inputsContainerView.addSubview(userNameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        // username textfield
        userNameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 10).isActive = true
        userNameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        userNameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        //userNameTextField.bottomAnchor.constraint(equalTo: userNameSeparatorView.topAnchor).isActive = true
        userNameHeightAnchor = userNameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        userNameHeightAnchor?.isActive = true
        
        // username separator view
        userNameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        userNameSeparatorView.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor).isActive = true
        userNameSeparatorView.widthAnchor.constraint(equalTo: userNameTextField.widthAnchor).isActive = true
        userNameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // email textField
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 10).isActive = true
        emailTextField.topAnchor.constraint(equalTo: userNameSeparatorView.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailHeightAnchor?.isActive = true
        
        // email separator view
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: emailTextField.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // password textfield
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 10).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor).isActive = true
        passwordTextField.bottomAnchor.constraint(equalTo: inputsContainerView.bottomAnchor).isActive = true
        passwordHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailHeightAnchor?.isActive = true
        
    }
    
    /// Handles settting up profile image layout constraints
    func setupProfileImage() {
        // profile image constraints
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -15).isActive = true
    }
    
    /// Handles setting up login button layout contraints
    func setupLoginButton() {
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200)
        loginButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    /// Handle setting up the "Or" label contraints label
    func setupLoginChoiceLabel() {
        loginChoiceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginChoiceLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 12).isActive = true
        loginChoiceLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        loginChoiceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    /// Handles setting up facebook login button layout constraints
    func setupFacebookLoginButton() {
        facebookLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        facebookLoginButton.topAnchor.constraint(equalTo: loginChoiceLabel.bottomAnchor, constant: 12).isActive = true
        facebookLoginButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        facebookLoginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    // Mark: - UITextFields Delegate Methods
    override func resignFirstResponder() -> Bool {
        passwordTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        self.navigationController?.pushViewController(completeProfileController, animated: true)
    }
    
    /// Toggle Login button
    func toggleLoginButton() {
        if (!(emailTextField.text?.isEmpty)!) || (!(passwordTextField.text?.isEmpty)!) || (!(userNameTextField.text?.isEmpty)!) {
            loginButton.isEnabled = true
            
        } else {
            loginButton.isEnabled = false
        }
    }
    
    /// Login button action
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
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
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                }
            })
        }
    }
    
    //TODO:-
    /**
     when user click on Login it will segue to usersList.
     when user click on register it will take them to CompleteProfileVC to submit a picture, age and state.
     
     */
    
}



