//
//  SwiftMessages+Config.swift
//  ChatHomie
//
//  Created by Youcef Bouhafna on 4/5/18.
//  Copyright © 2018 Youcef. All rights reserved.
//

import Foundation
import SwiftMessages
extension MessageView {
    /**
     Build the message view
     - Parameter title: Message title
     - Parameter body: message body
     - Parameter iconStyle: icon Style
     - Return MessageView:
 */
    static func buildMessage(withTitle title: String, body: String, layout: MessageView.Layout = .cardView, hideButton: Bool = true, addDropShadow: Bool = true) -> MessageView {
        let message = MessageView.viewFromNib(layout: layout)
        message.button?.isHidden = hideButton
        if addDropShadow {
            message.configureDropShadow()
        }
        message.configureContent(title: title, body: body)
        return message
    }
    
    /**
     Error message view
     - Parameter title: Message title
     - Parameter body: message body
     - Parameter iconStyle: icon Style
     - Return MessageView:
     
    */
    static func errorMessageView(withTitle title: String, body: String, iconStyle: IconStyle = .subtle) -> MessageView {
    let message = buildMessage(withTitle: title, body: body, layout: .cardView, hideButton: true, addDropShadow: true)
        message.configureTheme(.error, iconStyle: iconStyle)
        if title.isEmpty {
            message.titleLabel?.isHidden = true
        }
        
        if body.isEmpty {
           message.bodyLabel?.isHidden = true
        }
        return message
    }
    
    /**
     Warning message view
     - Parameter title: Message title
     - Parameter body: message body
     - Parameter iconStyle: icon Style
     - Return MessageView:
    */
    static func warningMessageView(withTitle title: String, body: String, iconStyle: IconStyle = .subtle) -> MessageView {
        let message = buildMessage(withTitle: title, body: body, layout: .cardView, hideButton: true, addDropShadow: true)
        message.configureTheme(.warning, iconStyle: iconStyle)
        return message
    }
    
    /**
     Success MessageView
     - Parameter title: Message title
     - Parameter body: message body
     - Parameter iconStyle: icon Style
     - Return MessageView:
    */
    static func successMessage(withTitle title: String, body: String, iconStyle: IconStyle = .subtle) -> MessageView {
        let message = buildMessage(withTitle: title, body: body, layout: .cardView, hideButton: true, addDropShadow: true)
        message.configureTheme(.success, iconStyle: iconStyle)
        return message
    }
    
}


