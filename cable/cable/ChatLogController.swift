//
//  ChatLogController.swift
//  cable
//
//  Created by Shane Alton on 7/10/17.
//  Copyright © 2017 Shane Alton. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
  
  private let cellId = "cellId"
  var messages = [Message]()
  var user: User? {
    didSet {
      navigationItem.title = user?.name
      observeConversation()
    }
  }
  
  func observeConversation() {
    guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
    let userMessages = FIRDatabase.database().reference().child("user-messages").child(uid)
    userMessages.observe(.childAdded, with: { (snapshot) in
      let messageId = snapshot.key
      let messagesRef = FIRDatabase.database().reference().child("messages").child(messageId)
      messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
        guard let dictionary = snapshot.value as? [String:AnyObject] else { return }
        let message = Message()
        message.setValuesForKeys(dictionary)
        
        if message.chatPartnerId() == self.user?.id {
         self.messages.append(message)
          DispatchQueue.main.async(execute: {
            self.collectionView?.reloadData()
          })
        }
      }, withCancel: nil)
    }, withCancel: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavBar()
    setupCollectionView()
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
  
  // Chat/message text input component with sticky keyboard.
  lazy var inputContainerView: UIView = {
    let container = UIView()
    container.translatesAutoresizingMaskIntoConstraints = false
    container.backgroundColor = .white
    container.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
    
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
    
    container.addSubview(separatorView)
    container.addSubview(sendButton)
    container.addSubview(self.messageInput)
    
    sendButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
    sendButton.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
    sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
    sendButton.heightAnchor.constraint(equalTo: container.heightAnchor).isActive = true
    
    self.messageInput.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
    self.messageInput.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
    self.messageInput.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
    self.messageInput.heightAnchor.constraint(equalTo: container.heightAnchor).isActive = true
    
    separatorView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
    separatorView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
    separatorView.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
    separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
    return container
  }()
  
  func handleSend() {
    let ref = FIRDatabase.database().reference().child("messages")
    let childRef = ref.childByAutoId()
    let toId = user!.id!
    let fromId = FIRAuth.auth()!.currentUser!.uid
    let timestamp = Int(NSDate().timeIntervalSince1970)
    let values = ["text": messageInput.text!, "toId": toId, "fromId": fromId, "timestamp": timestamp] as [String : Any]
    
    childRef.updateChildValues(values) { (error, ref) in
      if error != nil {
        print(error ?? "Error:")
        return
      }
      
      self.messageInput.text = nil
      let userMessages = FIRDatabase.database().reference().child("user-messages").child(fromId)
      let messageId = childRef.key
      userMessages.updateChildValues([messageId: 1])
      
      let recipient = FIRDatabase.database().reference().child("user-messages").child(toId)
      recipient.updateChildValues([messageId: 1])
    }
  }
  
  //attach a view to the top of the keyboard
  override var inputAccessoryView: UIView? {
    get{ return inputContainerView }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    handleSend()
    return true
  }
 
  //need this for attaching view to keyboard
  override var canBecomeFirstResponder: Bool { return true }
  
  fileprivate func setupNavBar() {
    self.navigationController?.navigationBar.tintColor = UIColor.rgb(red: 130, green: 122, blue: 210)
  }
  
  fileprivate func setupCollectionView() {
    self.collectionView?.register(ChatCell.self, forCellWithReuseIdentifier: cellId)
    //Add margins to collectionview to compensate for input area and chat bubbles. Also, adjusting scroll indicator insets to match new margins.
    collectionView?.contentInset = UIEdgeInsetsMake(18, 0, 58, 0)
    collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 50, 0)
    collectionView?.alwaysBounceVertical = true
    collectionView?.backgroundColor = .white
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return messages.count
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    var height: CGFloat = 80
    
    // Dynamic height for chat bubbles
    if let text = messages[indexPath.item].text {
      height = estimateFrameForMessage(text: text).height + 18
    }
    
    return CGSize(width: view.frame.width, height: height)
  }
  
  fileprivate func estimateFrameForMessage(text: String) -> CGRect {
    let size = CGSize(width: 200, height: 1000)
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    
    return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)], context: nil)
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatCell
    let message = self.messages[indexPath.item]
    cell.messageText.text = message.text
    
    //ISSUE REMINDER: Dynamic chat bubble width. Magic number compensates for text field.
    cell.chatBubbleWidthAnchor?.constant = estimateFrameForMessage(text: message.text!).width + 31
    
    return cell
  }
}

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
