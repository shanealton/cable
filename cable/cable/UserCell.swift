//
//  UserCell.swift
//  cable
//
//  Created by Shane Alton on 7/11/17.
//  Copyright © 2017 Shane Alton. All rights reserved.
//

import UIKit
import Firebase

class UserCell: BaseCell {
  
  var message: Message? {
    didSet {
      setupNameAndAvatar()
      detailLabel.text = message?.text
      
      if let seconds = message?.timestamp?.doubleValue {
        let timestampAsDate = NSDate(timeIntervalSince1970: seconds)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        timeLabel.text = dateFormatter.string(from: timestampAsDate as Date)
      }
    }
  }
  
  private func setupNameAndAvatar() {
    if let id = message?.chatPartnerId() {
      let ref = FIRDatabase.database().reference().child("users").child(id)
      ref.observe(.value, with: { (snapshot) in
        if let dictionary = snapshot.value as? [String:AnyObject] {
          self.nameLabel.text = dictionary["name"] as? String
        }
      }, withCancel: nil)
    }
  }
  
  let avatar: UIImageView = {
    let image = UIImageView()
    image.backgroundColor = .rgb(red: 235, green: 232, blue: 228)
    image.layer.cornerRadius = 20
    image.translatesAutoresizingMaskIntoConstraints = false
    return image
  }()
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let detailLabel: UILabel = {
    let label = UILabel()
    label.textColor = .rgb(red: 174, green: 174, blue: 174)
    label.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let timeLabel: UILabel = {
    let label = UILabel()
    label.textColor = .rgb(red: 174, green: 174, blue: 174)
    label.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightLight)
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
    addSubview(timeLabel)
    addSubview(separator)
    
    setupAvatar()
    setupName()
    setupDetail()
    setupTimeLabel()
    setupSeparator()
  }
  
  func setupAvatar() {
    avatar.anchorCenterYToSuperview()
    avatar.anchor(left: leftAnchor, leftConstant: 18, widthConstant: 40, heightConstant: 40)
  }
  
  func setupName() {
    nameLabel.anchor(avatar.topAnchor, left: avatar.rightAnchor, leftConstant: 15)
  }
  
  func setupDetail() {
    detailLabel.anchor(nameLabel.bottomAnchor, left: avatar.rightAnchor, right: rightAnchor, topConstant: 4, leftConstant: 15, rightConstant: 18)
  }
  
  func setupTimeLabel() {
    timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
    timeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -18).isActive = true
  }
  
  func setupSeparator() {
    separator.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, leftConstant: 73, heightConstant: 0.75)
  }
}
