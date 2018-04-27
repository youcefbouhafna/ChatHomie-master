//
//  Extensions.swift
//  gameofchats
//
//  Created by Brian Voong on 7/5/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

/**
 UITextField
 */
extension UITextField {
    func toggleKeyboardStatus(_ textField: UITextField) {
        if (textField.text?.isEmpty)! {
            textField.isEnabled = false
            textField.resignFirstResponder()
        } else {
            textField.isEnabled = true
            textField.becomeFirstResponder()
        }
    }
}

/**
 Image caching
 */
let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error ?? "")
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    self.image = downloadedImage
                }
            })
            
        }).resume()
    }
    
}

/// UIView
extension UIView {
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
    
    func addBackGroundImageBlurEffect() {
        let backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        let image = UIImage(named: "youcef")
        backgroundImageView.image = image
        self.addSubview(backgroundImageView)
        self.addBlurEffect()
    }
    
    
}

///UIColor
extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

///Adding testing accounts for sign in
extension LoginViewController {
   private struct Credentials {
        let email: String
        let password: String
    }
    
    private var accounts: [Credentials] {
        var accountsList = [Credentials]()
        accountsList = [Credentials(email: "joseph01@gmail.com", password: "431988"),
        Credentials(email: "joseph02@gmail.com", password: "431988"),
        Credentials(email: "frank01", password: "431988"),
        Credentials(email: "frank02", password: "431988")]
        return accountsList
    }
    
    func addNavigationBarButtons() {
        let loginTestAccount = UIBarButtonItem(title: "testLogin", style: .plain, target: self, action: #selector(showAccounts(_:)))
       // self.navigationItem.leftBarButtonItems = [loginTestAccount]
        self.navigationController?.navigationBar.topItem?.setLeftBarButton(loginTestAccount, animated: true)
    
    }
    
    @objc func showAccounts(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Login As", message: nil, preferredStyle: .actionSheet)
        for account in accounts {
            let credentialAction = UIAlertAction(title: account.email, style: .default) { (action) in
                self.emailTextField.text = account.email
                self.passwordTextField.text = account.password
            }
            
            alert.addAction(credentialAction)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)

    }
    
    
}

