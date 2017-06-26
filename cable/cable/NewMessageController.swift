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
  
  var users = [User]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavBar()
    setupCollectionView()
    
    fetchUser()
  }
  
  func fetchUser() {
    FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
      
      if let dictionary = snapshot.value as? [String: AnyObject] {
        let user = User()
        user.setValuesForKeys(dictionary)
        self.users.append(user)
        DispatchQueue.main.async(execute: {
          self.collectionView?.reloadData()
        })
      }
      
    })
  }
  
  fileprivate func setupNavBar() {
    self.navigationItem.title = "New Message"
    self.navigationController?.navigationBar.tintColor = UIColor.rgb(red: 130, green: 122, blue: 210)
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
  }
  
  fileprivate func setupCollectionView() {
    self.collectionView?.register(NewMessageCell.self, forCellWithReuseIdentifier: "cellId")
    collectionView?.backgroundColor = .white
  }
  
  func handleCancel() {
    self.dismiss(animated: true, completion: nil)
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return users.count
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 75)
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NewMessageCell
    let user = users[indexPath.item]
    cell.nameLabel.text = user.name
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}

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
    addSubview(separator)
    
    setupAvatar()
    setupName()
    setupSeparator()
  }
  
  func setupAvatar() {
    avatar.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    avatar.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    avatar.widthAnchor.constraint(equalToConstant: 35).isActive = true
    avatar.heightAnchor.constraint(equalToConstant: 35).isActive = true
  }
  
  func setupName() {
    nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    nameLabel.leftAnchor.constraint(equalTo: avatar.rightAnchor, constant: 10).isActive = true
  }
  
  func setupSeparator() {
    separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    separator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    separator.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
  }
}
