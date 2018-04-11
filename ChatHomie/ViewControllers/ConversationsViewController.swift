//
//  ConversationsViewController.swift
//  ChatHomie
//
//  Created by youcef bouhafna on 10/26/17.
//  Copyright © 2017 Youcef. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import Foundation
class ConversationsViewController: UITableViewController {
    
    let messageCellID = "messageCellID"
    var user:  UserListViewController?
    var messages = [Message]()
    var message: Message?
    var timer: Timer?
    var messagesDictionary =  [String: AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Conversations"
        tableView.register(ConversationCell.self, forCellReuseIdentifier: messageCellID)
        getUserMessages()
        
    }
    
    override  func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: messageCellID, for: indexPath) as! ConversationCell
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        guard let id = message.chatPartnerId() else {return }
        let ref = Database.database().reference().child("Users").child(id)
        ref.observe(.value, with: { (snapshot) in
            guard let jsonDictionary = snapshot.value as? [String: AnyObject] else {return}
            let user = User(withDictionary: jsonDictionary)
            user.id = id
            self.showChatScreen(user: user)
        }, withCancel: nil)
    }
    
    func showChatScreen(user: User) {
        let chatVC = ChatViewController()
        chatVC.user = user
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    
    
    func reloadDateOnTimer() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReload), userInfo: nil, repeats: false)
    }
    
    func handleReload() {
//        self.messages.sort(by: { (message1, message2) -> Bool in
//            
//            return message1.timeStamp > message2.timeStamp
//        })
//        
    }
    
    
    func getUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
                let userID = snapshot.key
            Database.database().reference().child("user-messages").child(uid).child(userID).observe(.childAdded, with: { (snapshot) in
                let messageID = snapshot.key
                self.getMessagesWith(messageID)
                
            }, withCancel: nil)
            
            
            
        }, withCancel: nil)
        
        DispatchQueue.main.async(execute: {
            self.tableView?.reloadData()
            self.reloadDateOnTimer()
        })
        
    }
    
    func getMessagesWith(_ messageIdentifier: String) {
        let ref = Database.database().reference().child("messages").child(messageIdentifier)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let jsonDictionary = snapshot.value as? [String: AnyObject] else {return}
            for item in jsonDictionary {
                if let messageDictionary = item.value as? [String: AnyObject] {
                    let message = Message(dictionary: messageDictionary)
                    self.messages.append(message!)
                }
            }
        })
        
    }
}
