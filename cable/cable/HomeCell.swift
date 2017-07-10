//
//  HomeCell.swift
//  cable
//
//  Created by Shane Alton on 6/23/17.
//  Copyright © 2017 Shane Alton. All rights reserved.
//

import UIKit

class HomeCell: BaseCell {
  
  let messageText: UILabel = {
    let label = UILabel()
    label.text = "Default message"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override func setupViews() {
    super.setupViews()
    
    addSubview(messageText)
    
    setupMessage()
  }
  
  func setupMessage() {
    messageText.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    messageText.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
  }
}
