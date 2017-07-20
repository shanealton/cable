//
//  Message.swift
//  cable
//
//  Created by Shane Alton on 7/10/17.
//  Copyright © 2017 Shane Alton. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
  var fromId: String?
  var text: String?
  var timestamp: NSNumber?
  var toId: String?
  
  var imageUrl: String?
  var imageWidth: NSNumber?
  var imageHeight: NSNumber?
  
  func chatPartnerId() -> String? {
    return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId
  }
  
  init(dictionary: [String:AnyObject]) {
    super.init()
    
    fromId = dictionary["fromId"] as? String
    text = dictionary["text"] as? String
    timestamp = dictionary["timestamp"] as? NSNumber
    toId = dictionary["toId"] as? String
    
    imageUrl = dictionary["imageUrl"] as? String
    imageWidth = dictionary["imageWidth"] as? NSNumber
    imageHeight = dictionary["imageHeight"] as? NSNumber
  }
}
