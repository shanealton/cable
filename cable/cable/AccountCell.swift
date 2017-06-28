//
//  AccountCell.swift
//  cable
//
//  Created by Shane Alton on 6/28/17.
//  Copyright © 2017 Shane Alton. All rights reserved.
//

import UIKit


class AccountHeaderCell: BaseCell {
  
  override func setupViews() {
    super.setupViews()
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
    separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    separator.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    separator.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
  }
}
