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
    
    setupCollectionView()
  }
  
  fileprivate func setupCollectionView() {
    self.collectionView?.register(HomeCell.self, forCellWithReuseIdentifier: "cellId")
    collectionView?.backgroundColor = .white
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 2
  }
  
  
 
}

class HomeCell: BaseCell {
  
  override func setupViews() {
    super.setupViews()
    
  }
}
