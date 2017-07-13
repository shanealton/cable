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
      let messageId = snapshot.key
      let messageReference = FIRDatabase.database().reference().child("messages").child(messageId)
      
      messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
        if let dictionary = snapshot.value as? [String: AnyObject] {
          let message = Message()
          message.setValuesForKeys(dictionary)
          
          if let toId = message.toId {
            self.messagesDictionary[toId] = message
            self.messages = Array(self.messagesDictionary.values)
            self.messages.sort(by: { (message1, message2) -> Bool in
              return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
            })
          }
          
          DispatchQueue.main.async(execute: {
            self.collectionView?.reloadData()
          })
        }
      }, withCancel: nil)
  
      
    }, withCancel: nil)
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
