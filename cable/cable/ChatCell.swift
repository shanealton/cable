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
  var chatBubbleRightAnchor: NSLayoutConstraint?
  var chatBubbleLeftAnchor:  NSLayoutConstraint?
  
  let messageText: UITextView = {
    let text = UITextView()
    text.backgroundColor = .clear
    text.textColor = .white
    text.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightRegular)
    text.translatesAutoresizingMaskIntoConstraints = false
    text.isEditable = false
    return text
  }()
  
  let chatBubble: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 18
    view.backgroundColor = .rgb(red: 130, green: 122, blue: 210)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let avatar: UIImageView = {
    let image = UIImageView()
    image.layer.cornerRadius = 16
    image.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
    image.layer.masksToBounds = true
    image.contentMode = .scaleAspectFill
    image.translatesAutoresizingMaskIntoConstraints = false
    return image
  }()
  
  let messageImageView: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.layer.masksToBounds = true
    image.layer.cornerRadius = 18
    image.contentMode = .scaleAspectFill
    return image
  }()
  
  override func setupViews() {
    super.setupViews()
    
    addSubview(avatar)
    addSubview(chatBubble)
    setupAvatar()
    setupChatBubble()
  }
  
  func setupAvatar() {
    avatar.leftAnchor.constraint(equalTo: leftAnchor, constant: 18).isActive = true
    avatar.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    avatar.widthAnchor.constraint(equalToConstant: 32).isActive = true
    avatar.heightAnchor.constraint(equalToConstant: 32).isActive = true
  }
  
  func setupChatBubble() {
    chatBubble.topAnchor.constraint(equalTo: topAnchor).isActive = true
    chatBubble.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    
    chatBubbleWidthAnchor = chatBubble.widthAnchor.constraint(equalToConstant: 200)
    chatBubbleWidthAnchor?.isActive = true
    
    chatBubbleRightAnchor = chatBubble.rightAnchor.constraint(equalTo: rightAnchor, constant: -18)
    chatBubbleRightAnchor?.isActive = true
    
    chatBubbleLeftAnchor = chatBubble.leftAnchor.constraint(equalTo: avatar.rightAnchor, constant: 8)

    chatBubble.addSubview(messageText)
    chatBubble.addSubview(messageImageView)
    setupMessage()
    setupMessageImage()
  }
  
  func setupMessage() {
    messageText.topAnchor.constraint(equalTo: chatBubble.topAnchor).isActive = true
    messageText.leftAnchor.constraint(equalTo: chatBubble.leftAnchor, constant: 10).isActive = true
    messageText.rightAnchor.constraint(equalTo: chatBubble.rightAnchor, constant: -10).isActive = true
    messageText.heightAnchor.constraint(equalTo: chatBubble.heightAnchor).isActive = true
  }
  
  func setupMessageImage() {
    messageImageView.leftAnchor.constraint(equalTo: chatBubble.leftAnchor).isActive = true
    messageImageView.topAnchor.constraint(equalTo: chatBubble.topAnchor).isActive = true
    messageImageView.widthAnchor.constraint(equalTo: chatBubble.widthAnchor).isActive = true
    messageImageView.heightAnchor.constraint(equalTo: chatBubble.heightAnchor).isActive = true
  }
}
