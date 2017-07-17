//
//  HomeController+handlers.swift
//  cable
//
//  Created by Shane Alton on 6/28/17.
//  Copyright © 2017 Shane Alton. All rights reserved.
//

import UIKit
import Firebase


extension HomeController {
  
  // Check if user is currently logged in.
  func handleAuth() {
    if FIRAuth.auth()?.currentUser?.uid == nil {
      perform(#selector(handleLogout), with: nil, afterDelay: 0)
    } else {
      guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
      FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
        if let dictionary = snapshot.value as? [String: AnyObject] {
          self.navigationItem.title = dictionary["name"] as? String
          let user = User()
          self.setupUserConversations(user: user)
        }
      })
    }
  }
  
  func setupUserConversations(user: User) {
    messages.removeAll()
    messagesDictionary.removeAll()
    collectionView?.reloadData()
    observeUserMessages()
  }
  
  func observeUserMessages() {
    guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
    let ref = FIRDatabase.database().reference().child("user-messages").child(uid)
    ref.observe(.childAdded, with: { (snapshot) in
      let userId = snapshot.key
      FIRDatabase.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
        let messageId = snapshot.key
        self.fetchMessageWithMessageId(messageId: messageId)
      }, withCancel: nil)
    }, withCancel: nil)
  }
  
  private func fetchMessageWithMessageId(messageId: String) {
    let messageReference = FIRDatabase.database().reference().child("messages").child(messageId)
    messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
      if let dictionary = snapshot.value as? [String: AnyObject] {
        let message = Message()
        message.setValuesForKeys(dictionary)
        
        if let chatPartnerId = message.chatPartnerId() {
          self.messagesDictionary[chatPartnerId] = message
        }
        
        self.attemptReload()
      }
    }, withCancel: nil)
  }
  
  private func attemptReload() {
    self.timer?.invalidate()
    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReload), userInfo: nil, repeats: false)
  }
  
  func handleReload() {
    self.messages = Array(self.messagesDictionary.values)
    self.messages.sort(by: { (message1, message2) -> Bool in
      return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
    })
    
    DispatchQueue.main.async(execute: {
      self.collectionView?.reloadData()
    })
  }
  
  // Logout the current user.
  func handleLogout() {
    do { try FIRAuth.auth()?.signOut() } catch let err {
      print(err)
    }
    
    let loginController = LoginController()
    present(loginController, animated: false, completion: nil)
  }
  
  // Present the new message controller.
  func handleNewMessage() {
    let newMessageController = NewMessageController(collectionViewLayout: UICollectionViewFlowLayout())
    newMessageController.homeController = self
    present(UINavigationController(rootViewController: newMessageController), animated: true, completion: nil)
  }
  
  func showConversation(_ user: User) {
    let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
    chatLogController.user = user
    navigationController?.pushViewController(chatLogController, animated: true)
  }
  
  //Chat log controller
  func handleChatLog(user: User) {
    let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
    chatLogController.user = user
    navigationController?.pushViewController(chatLogController, animated: true)
  }
  
  // Present the account settings controller.
  func handleAccount() {
    let accountController = AccountController(collectionViewLayout: UICollectionViewFlowLayout())
    present(UINavigationController(rootViewController: accountController), animated: true, completion: nil)
  }
}
