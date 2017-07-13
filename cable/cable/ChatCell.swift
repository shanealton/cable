//
//  ChatCell.swift
//  cable
//
//  Created by Shane Alton on 7/13/17.
//  Copyright © 2017 Shane Alton. All rights reserved.
//

import UIKit

class ChatCell: BaseCell {
  
  var chatBubbleWidthAnchor: NSLayoutConstraint?
  
  let messageText: UITextView = {
    let text = UITextView()
    text.backgroundColor = .clear
    text.textColor = .white
    text.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightRegular)
    text.translatesAutoresizingMaskIntoConstraints = false
    return text
  }()
  
  let chatBubble: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 18
    view.backgroundColor = .rgb(red: 130, green: 122, blue: 210)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  override func setupViews() {
    super.setupViews()
    
    addSubview(chatBubble)
    
    setupChatBubble()
  }
  
  func setupChatBubble() {
    chatBubble.topAnchor.constraint(equalTo: topAnchor).isActive = true
    chatBubbleWidthAnchor = chatBubble.widthAnchor.constraint(equalToConstant: 200)
    chatBubbleWidthAnchor?.isActive = true
    chatBubble.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    chatBubble.rightAnchor.constraint(equalTo: rightAnchor, constant: -18).isActive = true
    
    chatBubble.addSubview(messageText)
    setupMessage()
  }
  
  func setupMessage() {
    messageText.topAnchor.constraint(equalTo: chatBubble.topAnchor).isActive = true
    messageText.leftAnchor.constraint(equalTo: chatBubble.leftAnchor, constant: 10).isActive = true
    messageText.rightAnchor.constraint(equalTo: chatBubble.rightAnchor, constant: -10).isActive = true
    messageText.heightAnchor.constraint(equalTo: chatBubble.heightAnchor).isActive = true
  }
}
