//
//  ChatLogController+handlers.swift
//  cable
//
//  Created by Shane Alton on 7/13/17.
//  Copyright © 2017 Shane Alton. All rights reserved.
//

import UIKit
import Firebase

extension ChatLogController {
  
  // Fetch conversation
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
  
  // Send message to Firebase
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
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    handleSend()
    return true
  }
  
}

