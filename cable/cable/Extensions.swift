//
//  Extensions.swift
//  cable
//
//  Created by Shane Alton on 6/22/17.
//  Copyright © 2017 Shane Alton. All rights reserved.
//

import UIKit


// Base class for new UICollectionView cells
class BaseCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  func setupViews() {}
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// Status bar customization
extension UIApplication {
  var statusBarView: UIView? {
    return value(forKey: "statusBar") as? UIView
  }
}

// RGB color creation
extension UIColor {
  static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
    return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
  }
}
