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
  var user: User? {
    didSet {
      navigationItem.title = user?.name
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavBar()
    setupCollectionView()
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
//    childRef.updateChildValues(values)
    
    childRef.updateChildValues(values) { (error, ref) in
      if error != nil {
        print(error ?? "Error:")
        return
      }
      
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
    collectionView?.backgroundColor = .white
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 75)
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatCell
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}

class ChatCell: BaseCell {
  
  override func setupViews() {
    super.setupViews()
    
  }
}
