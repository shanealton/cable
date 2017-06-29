//
//  AccountCell.swift
//  cable
//
//  Created by Shane Alton on 6/28/17.
//  Copyright © 2017 Shane Alton. All rights reserved.
//

import UIKit

class AccountHeaderCell: BaseCell {
  
  lazy var imageContainer: UIView = {
    let view = UIView()
    view.isUserInteractionEnabled = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let avatar: UIImageView = {
    let image = UIImageView()
    image.backgroundColor = .rgb(red: 235, green: 232, blue: 228)
    image.layer.cornerRadius = 20
    image.translatesAutoresizingMaskIntoConstraints = false
    return image
  }()
  
  let cameraIcon: UIImageView = {
    let image = UIImageView()
    image.backgroundColor = .gray
    image.layer.cornerRadius = 7.5
    image.translatesAutoresizingMaskIntoConstraints = false
    return image
  }()
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.text = ""
    label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let emailLabel: UILabel = {
    let label = UILabel()
    label.text = ""
    label.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightRegular)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override func setupViews() {
    super.setupViews()
    
    addSubview(imageContainer)
    addSubview(nameLabel)
    addSubview(emailLabel)
    
    setupImageContainer()
    setupNameLabel()
    setupEmailLabel()
  }
  
  func setupImageContainer() {
    imageContainer.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    imageContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 18).isActive = true
    imageContainer.widthAnchor.constraint(equalToConstant: 50).isActive = true
    imageContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    imageContainer.addSubview(avatar)
    
    setupAvatar()
  }
  
  func setupAvatar() {
    avatar.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor).isActive = true
    avatar.leftAnchor.constraint(equalTo: imageContainer.leftAnchor).isActive = true
    avatar.widthAnchor.constraint(equalToConstant: 40).isActive = true
    avatar.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    avatar.addSubview(cameraIcon)
    setupCameraIcon()
  }
  
  func setupCameraIcon() {
    cameraIcon.bottomAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 1).isActive = true
    cameraIcon.rightAnchor.constraint(equalTo: avatar.rightAnchor, constant: 1).isActive = true
    cameraIcon.widthAnchor.constraint(equalToConstant: 15).isActive = true
    cameraIcon.heightAnchor.constraint(equalToConstant: 15).isActive = true
  }
  
  func setupNameLabel() {
    nameLabel.topAnchor.constraint(equalTo: avatar.topAnchor).isActive = true
    nameLabel.leftAnchor.constraint(equalTo: imageContainer.rightAnchor, constant: 10).isActive = true
  }
  
  func setupEmailLabel() {
    emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
    emailLabel.leftAnchor.constraint(equalTo: imageContainer.rightAnchor, constant: 10).isActive = true
  }
}

class AccountCell: BaseCell {
  
  let settingLabel: UILabel = {
    let label = UILabel()
    label.text = "Setting"
    label.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular)
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
    
    addSubview(settingLabel)
    addSubview(separator)
    
    setupSettingLabel()
    setupSeparator()
  }
  
  func setupSettingLabel() {
    settingLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    settingLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
  }
  
  func setupSeparator() {
    separator.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, leftConstant: 16, heightConstant: 0.75)
  }
}
