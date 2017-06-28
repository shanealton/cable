//
//  NewMessageCell.swift
//  cable
//
//  Created by Shane Alton on 6/28/17.
//  Copyright © 2017 Shane Alton. All rights reserved.
//

import UIKit

class NewMessageCell: BaseCell {
  
  let avatar: UIImageView = {
    let image = UIImageView()
    image.backgroundColor = .rgb(red: 235, green: 232, blue: 228)
    image.layer.cornerRadius = 17.5
    image.translatesAutoresizingMaskIntoConstraints = false
    return image
  }()
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.text = "Username"
    label.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let detailLabel: UILabel = {
    let label = UILabel()
    label.text = "Email"
    label.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightLight)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let separator: UIView = {
    let view = UIView()
    view.backgroundColor = .rgb(red: 235, green: 232, blue: 228)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  override func setupViews() {
    super.setupViews()
    
    addSubview(avatar)
    addSubview(nameLabel)
    addSubview(detailLabel)
    addSubview(separator)
    
    setupAvatar()
    setupName()
    setupDetail()
    setupSeparator()
  }
  
  func setupAvatar() {
    avatar.anchorCenterYToSuperview()
    avatar.anchor(left: leftAnchor, leftConstant: 16, widthConstant: 35, heightConstant: 35)
  }
  
  func setupName() {
    nameLabel.anchor(avatar.topAnchor, left: avatar.rightAnchor, leftConstant: 10)
  }
  
  func setupDetail() {
    detailLabel.anchor(nameLabel.bottomAnchor, left: avatar.rightAnchor, topConstant: 4, leftConstant: 10)
  }
  
  func setupSeparator() {
    separator.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, leftConstant: 61, heightConstant: 0.75)
  }
}
