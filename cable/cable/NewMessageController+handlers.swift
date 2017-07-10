//
//  NewMessageController+handlers.swift
//  cable
//
//  Created by Shane Alton on 6/28/17.
//  Copyright © 2017 Shane Alton. All rights reserved.
//

import UIKit
import Firebase

extension NewMessageController {
  
  // API Requests
  
  func fetchUser() {
    FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
      
      if let dictionary = snapshot.value as? [String: AnyObject] {
        let user = User()
        user.id = snapshot.key
        user.setValuesForKeys(dictionary)
        self.users.append(user)
        DispatchQueue.main.async(execute: {
          self.collectionView?.reloadData()
        })
      }
    })
  }
  
  func handleDismiss() {
    self.dismiss(animated: true, completion: nil)
  }
}
