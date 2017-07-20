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
  
  func observeConversation() {
    guard let uid = FIRAuth.auth()?.currentUser?.uid, let toId = user?.id else { return }
    let userMessages = FIRDatabase.database().reference().child("user-messages").child(uid).child(toId)
    userMessages.observe(.childAdded, with: { (snapshot) in
      let messageId = snapshot.key
      let messagesRef = FIRDatabase.database().reference().child("messages").child(messageId)
      messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
        guard let dictionary = snapshot.value as? [String:AnyObject] else { return }
        self.messages.append(Message(dictionary: dictionary))
        DispatchQueue.main.async(execute: {
          self.collectionView?.reloadData()
        })
      }, withCancel: nil)
    }, withCancel: nil)
  }
  
  func handleImage() {
    let imagePickerController = UIImagePickerController()
    imagePickerController.allowsEditing = true
    imagePickerController.delegate = self
    present(imagePickerController, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    var selectedImageFromPicker: UIImage?
    
    if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
      selectedImageFromPicker = editedImage
    } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
      
      selectedImageFromPicker = originalImage
    }
    
    if let selectedImage = selectedImageFromPicker {
      uploadToFirebaseStorageUsingImage(selectedImage)
    }
    
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  fileprivate func uploadToFirebaseStorageUsingImage(_ image: UIImage) {
    let imageName = UUID().uuidString
    let ref = FIRStorage.storage().reference().child("message_images").child(imageName)
    
    if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
      ref.put(uploadData, metadata: nil, completion: { (metadata, error) in
        
        if error != nil {
          print("Failed to upload image:", error!)
          return
        }
        
        if let imageUrl = metadata?.downloadURL()?.absoluteString {
          self.sendMessageWithImageUrl(imageUrl, image: image)
        }
      })
    }
  }
  
  fileprivate func sendMessageWithProperties(properties: [String: AnyObject]) {
    let ref = FIRDatabase.database().reference().child("messages")
    let childRef = ref.childByAutoId()
    let toId = user!.id!
    let fromId = FIRAuth.auth()!.currentUser!.uid
    let timestamp = Int(Date().timeIntervalSince1970)
    
    var values = ["toId": toId, "fromId": fromId, "timestamp": timestamp] as [String : Any]
    
    properties.forEach({values[$0] = $1})
    
    childRef.updateChildValues(values) { (error, ref) in
      if error != nil {
        print(error ?? "Error:")
        return
      }
      
      self.messageInput.text = nil
      let userMessages = FIRDatabase.database().reference().child("user-messages").child(fromId).child(toId)
      let messageId = childRef.key
      userMessages.updateChildValues([messageId: 1])
      
      let recipient = FIRDatabase.database().reference().child("user-messages").child(toId).child(fromId)
      recipient.updateChildValues([messageId: 1])
    }
  }
  
  func handleSend() {
    let properties = ["text": messageInput.text!] as [String : AnyObject]
    sendMessageWithProperties(properties: properties)
  }
  
  fileprivate func sendMessageWithImageUrl(_ imageUrl: String, image: UIImage) {
    let properties = ["imageUrl": imageUrl, "imageWidth": image.size.width, "imageHeight": image.size.height] as [String: AnyObject]
    sendMessageWithProperties(properties: properties)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    handleSend()
    return true
  }
}
