//
//  NewMessageController.swift
//  cable
//
//  Created by Shane Alton on 6/26/17.
//  Copyright © 2017 Shane Alton. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  
  private let cellId = "cellId"
  var homeController: HomeController?
  var users = [User]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavBar()
    setupCollectionView()
    
    fetchUser()
  }
  
  fileprivate func setupNavBar() {
    self.navigationItem.title = "New Message"
    self.navigationController?.navigationBar.tintColor = UIColor.rgb(red: 130, green: 122, blue: 210)
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleDismiss))
  }
  
  fileprivate func setupCollectionView() {
    self.collectionView?.register(UserCell.self, forCellWithReuseIdentifier: cellId)
    collectionView?.backgroundColor = .white
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return users.count
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 75)
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserCell
    let user = users[indexPath.item]
    cell.nameLabel.text = user.name
    cell.detailLabel.text = user.email
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    dismiss(animated: true) { 
      let user = self.users[indexPath.item]
      self.homeController?.handleChatLog(user: user)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}
