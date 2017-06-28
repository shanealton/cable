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
    avatar.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    avatar.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    avatar.widthAnchor.constraint(equalToConstant: 35).isActive = true
    avatar.heightAnchor.constraint(equalToConstant: 35).isActive = true
  }
  
  func setupName() {
    nameLabel.topAnchor.constraint(equalTo: avatar.topAnchor).isActive = true
    nameLabel.leftAnchor.constraint(equalTo: avatar.rightAnchor, constant: 10).isActive = true
  }
  
  func setupDetail() {
    detailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
    detailLabel.leftAnchor.constraint(equalTo: avatar.rightAnchor, constant: 10).isActive = true
  }
  
  func setupSeparator() {
    separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    separator.leftAnchor.constraint(equalTo: leftAnchor, constant: 61).isActive = true
    separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    separator.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
  }
}
