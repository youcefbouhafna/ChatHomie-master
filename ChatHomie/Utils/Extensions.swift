//
//  Extensions.swift
//  gameofchats
//
//  Created by Brian Voong on 7/5/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

// Mark: - UITextField
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

// Mark: - UIImageView
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

// Mark: -  UIView
extension UIView {
    /**
     Method to Add blue effect
    */
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
    
    /**
     Method to add background image blur effect
    */
    func addBackGroundImageBlurEffect() {
        let backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        let image = UIImage(named: "youcef")
        backgroundImageView.image = image
        self.addSubview(backgroundImageView)
        self.addBlurEffect()
    }
    
    
    func anchorSize(view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    /**
     Method to set the constraints
     - Parameter top: top constraint
     - Parameter bottom: bottom constraint
     - Parameter leading: leading constraint
     - Parameter trailing: trailing constraint
     - Parameter constant: constant to give between the constraints
     - Parameter size: size of the constraint (width and height)
     
    */
    func setConstraints(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, leading: NSLayoutXAxisAnchor?, constant: UIEdgeInsets = .zero, size: CGSize = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top , constant: constant.top).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: constant.bottom).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: constant.left).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: constant.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}

// Mark: - UIColor
extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

// Mark: - Adding testing accounts for sign in
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
}

