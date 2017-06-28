//
//  AccountController.swift
//  cable
//
//  Created by Shane Alton on 6/27/17.
//  Copyright © 2017 Shane Alton. All rights reserved.
//

import UIKit
import Firebase

class AccountController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  
  private let cellId = "cellId"
  private let headerId = "headerId"
  
  let settings = ["Profile", "Account Settings", "Privacy", "Sign Out"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavBar()
    setupCollectionView()
  }
  
  fileprivate func setupNavBar() {
    self.navigationItem.title = "Settings"
    self.navigationController?.navigationBar.tintColor = UIColor.rgb(red: 130, green: 122, blue: 210)
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismiss))
  }
  
  func handleDismiss() {
    self.dismiss(animated: true, completion: nil)
  }
  
  fileprivate func setupCollectionView() {
    collectionView?.backgroundColor = .white
    collectionView?.register(AccountHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
    collectionView?.register(AccountCell.self, forCellWithReuseIdentifier: cellId)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: view.frame.width, height: 100)
  }
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AccountHeaderCell
    return header
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 50)
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AccountCell
    cell.settingLabel.text = settings[indexPath.item]
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if indexPath.item == 3 {
      handleLogout()
    }
  }
  
  func handleLogout() {
    do { try FIRAuth.auth()?.signOut() } catch let err {
      print(err)
    }
    
    let loginController = LoginController()
    self.dismiss(animated: false, completion: nil)
    present(loginController, animated: false, completion: nil)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}

class AccountHeaderCell: BaseCell {
  
  override func setupViews() {
    super.setupViews()
    backgroundColor = .rgb(red: 235, green: 232, blue: 228)
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
