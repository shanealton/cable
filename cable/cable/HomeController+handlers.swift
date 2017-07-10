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
        print(snapshot)
        if let dictionary = snapshot.value as? [String: AnyObject] {
          self.navigationItem.title = dictionary["name"] as? String
        }
      })
    }
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
