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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    handleAuth()
    
    setupNavBar()
    setupCollectionView()
  }
  
  // Check if user is currently logged in.
  func handleAuth() {
    if FIRAuth.auth()?.currentUser?.uid == nil {
      perform(#selector(handleLogout), with: nil, afterDelay: 0)
    } else {
      guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
      FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
        print(snapshot)
        if let dictionary = snapshot.value as? [String: AnyObject] {
          self.navigationItem.title = dictionary["name"] as? String
        }
        
      })
    }
  }
  
  fileprivate func setupNavBar() {
    self.navigationController?.navigationBar.tintColor = UIColor.rgb(red: 130, green: 122, blue: 210)
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage))
  }
  
  fileprivate func setupCollectionView() {
    self.collectionView?.register(HomeCell.self, forCellWithReuseIdentifier: "cellId")
    collectionView?.backgroundColor = .white
  }
  
  func handleLogout() {
    // Show LoginController on user sign-out.
    do { try FIRAuth.auth()?.signOut() } catch let err {
      print(err)
    }
    
    let loginController = LoginController()
    present(loginController, animated: false, completion: nil)
  }
  
  func handleNewMessage() {
    let newMessageController = NewMessageController(collectionViewLayout: UICollectionViewFlowLayout())
    present(UINavigationController(rootViewController: newMessageController), animated: true, completion: nil)
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 50)
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeCell
    return cell
  }
}
