//
//  ChatLogController.swift
//  cable
//
//  Created by Shane Alton on 7/10/17.
//  Copyright © 2017 Shane Alton. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  private let cellId = "cellId"
  var messages = [Message]()
  var user: User? {
    didSet {
      navigationItem.title = user?.name
      observeConversation()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavBar()
    setupCollectionView()
  }
  
  fileprivate func setupNavBar() {
    self.navigationController?.navigationBar.tintColor = UIColor.rgb(red: 130, green: 122, blue: 210)
  }
  
  fileprivate func setupCollectionView() {
    self.collectionView?.register(ChatCell.self, forCellWithReuseIdentifier: cellId)
    collectionView?.contentInset = UIEdgeInsetsMake(18, 0, 18, 0)
    collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
    collectionView?.alwaysBounceVertical = true
    collectionView?.keyboardDismissMode = .interactive
    collectionView?.backgroundColor = .white
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    
    coordinator.animate(alongsideTransition: { (context) in
      self.collectionView?.collectionViewLayout.invalidateLayout()
    }, completion: nil)
  }
  
  lazy var messageInput: UITextField = {
    let message = UITextField()
    message.placeholder = "Type a message..."
    message.translatesAutoresizingMaskIntoConstraints = false
    message.delegate = self
    message.becomeFirstResponder()
    return message
  }()
  
  lazy var inputContainerView: UIView = {
    let container = UIView()
    container.translatesAutoresizingMaskIntoConstraints = false
    container.backgroundColor = .white
    container.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)

    let uploadImage: UIImageView = {
      let image = UIImageView()
      image.image = UIImage(named: "upload_image_icon")
      image.translatesAutoresizingMaskIntoConstraints = false
      return image
    }()
    uploadImage.isUserInteractionEnabled = true
    uploadImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImage)))
    
    let sendButton: UIButton = {
      let button = UIButton(type: .system)
      button.setTitle("Send", for: .normal)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.tintColor = UIColor.rgb(red: 97, green: 126, blue: 201)
      button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
      return button
    }()
    
    let separatorView: UIView = {
      let view = UIView()
      view.translatesAutoresizingMaskIntoConstraints = false
      view.backgroundColor = UIColor.rgb(red: 235, green: 232, blue: 228)
      return view
    }()
    
    container.addSubview(uploadImage)
    container.addSubview(separatorView)
    container.addSubview(sendButton)
    container.addSubview(self.messageInput)
    
    uploadImage.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
    uploadImage.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 5).isActive = true
    uploadImage.widthAnchor.constraint(equalToConstant: 44).isActive = true
    uploadImage.heightAnchor.constraint(equalToConstant: 44).isActive = true
    
    sendButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
    sendButton.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
    sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
    sendButton.heightAnchor.constraint(equalTo: container.heightAnchor).isActive = true
    
    self.messageInput.leftAnchor.constraint(equalTo: uploadImage.rightAnchor, constant: 8).isActive = true
    self.messageInput.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
    self.messageInput.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
    self.messageInput.heightAnchor.constraint(equalTo: container.heightAnchor).isActive = true
    
    separatorView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
    separatorView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
    separatorView.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
    separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
    return container
  }()
  
  override var inputAccessoryView: UIView? {
    get{ return inputContainerView }
  }
  
  override var canBecomeFirstResponder: Bool { return true }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return messages.count
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    var height: CGFloat = 80
    
    let message = messages[indexPath.item]
    
    if let text = message.text {
      height = estimateFrameForMessage(text).height + 18
    } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
      height = CGFloat(imageHeight / imageWidth * 200)
    }
    
    return CGSize(width: view.frame.width, height: height)
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatCell
    let message = self.messages[indexPath.item]
    cell.messageText.text = message.text
    
    setupCell(cell: cell, message: message)
    
    if let text = message.text {
      cell.chatBubbleWidthAnchor?.constant = estimateFrameForMessage(text).width + 31
    } else if message.imageUrl != nil {
      cell.chatBubbleWidthAnchor?.constant = 220
    }
    return cell
  }
  
  fileprivate func estimateFrameForMessage(_ text: String) -> CGRect {
    let size = CGSize(width: 200, height: 1000)
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    
    return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)], context: nil)
  }
  
  fileprivate func setupCell(cell: ChatCell, message: Message) {
    if let messageImageUrl = message.imageUrl {
      cell.messageImageView.loadImageUsingCacheWithUrlString(messageImageUrl)
      cell.messageImageView.isHidden = false
      cell.chatBubble.backgroundColor = .clear
    } else {
      cell.messageImageView.isHidden = true
    }
    
    if message.fromId == FIRAuth.auth()?.currentUser?.uid {
      cell.chatBubble.backgroundColor = UIColor.rgb(red: 130, green: 122, blue: 210)
      cell.messageText.textColor = .white
      
      cell.chatBubbleRightAnchor?.isActive = true
      cell.chatBubbleLeftAnchor?.isActive = false
    } else {
      cell.chatBubble.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
      cell.messageText.textColor = .black
      
      cell.chatBubbleRightAnchor?.isActive = false
      cell.chatBubbleLeftAnchor?.isActive = true
    }
  }
}
