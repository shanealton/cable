//
//  HomeController.swift
//  cable
//
//  Created by Shane Alton on 6/22/17.
//  Copyright © 2017 Shane Alton. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  
  fileprivate let cellId = "cellId"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavBar()
    setupCollectionView()
  }
  
  fileprivate func setupNavBar() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
  }
  
  func handleLogout() {
    let loginController = LoginController()
    present(loginController, animated: true, completion: nil)
  }
  
  fileprivate func setupCollectionView() {
    self.collectionView?.register(HomeCell.self, forCellWithReuseIdentifier: "cellId")
    collectionView?.backgroundColor = .white
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

class HomeCell: BaseCell {
  
  override func setupViews() {
    super.setupViews()

  }
}
