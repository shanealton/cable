//
//  HomeController.swift
//  cable
//
//  Created by Shane Alton on 6/22/17.
//  Copyright © 2017 Shane Alton. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  
  private let cellId = "cellId"
  var messages = [Message]()
  var messagesDictionary = [String:Message] ()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setupNavBar()
    setupCollectionView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    handleAuth()
  }
  
  fileprivate func setupNavBar() {
    self.navigationController?.navigationBar.tintColor = UIColor.rgb(red: 130, green: 122, blue: 210)
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    let account = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleAccount))
    let compose = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage))
    navigationItem.rightBarButtonItems = [account, compose]
  }
  
  fileprivate func setupCollectionView() {
    self.collectionView?.register(UserCell.self, forCellWithReuseIdentifier: "cellId")
    collectionView?.backgroundColor = .white
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return messages.count
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 75)
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserCell
    let message = messages[indexPath.item]
    cell.message = message
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let message = messages[indexPath.item]
    
    guard let chatPartnerId = message.chatPartnerId() else { return }
    let ref = FIRDatabase.database().reference().child("users").child(chatPartnerId)
    
    ref.observeSingleEvent(of: .value, with: { (snapshot) in
      guard let dictionary = snapshot.value as? [String:AnyObject] else { return }
      let user = User()
      user.id = chatPartnerId
      user.setValuesForKeys(dictionary)
      self.showConversation(user)
    }, withCancel: nil)

  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}
