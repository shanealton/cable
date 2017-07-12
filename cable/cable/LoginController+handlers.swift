//
//  LoginController+handlers.swift
//  cable
//
//  Created by Shane Alton on 6/27/17.
//  Copyright © 2017 Shane Alton. All rights reserved.
//

import UIKit
import Firebase

extension LoginController {
  
  // Segmented Control Sections
  
  func handleControlChange() {
    let title = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)
    registerButton.setTitle(title, for: .normal)
    
    inputsContainerViewHeightAnchor?.constant = segmentedControl.selectedSegmentIndex == 0 ? 100 : 150
    
    nameTextFieldHeightAnchor?.isActive = false
    nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: segmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
    nameTextFieldHeightAnchor?.isActive = true
    
    nameSeparator.isHidden = segmentedControl.selectedSegmentIndex == 0 ? true : false
    
    emailTextFieldHeightAnchor?.isActive = false
    emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: segmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
    emailTextFieldHeightAnchor?.isActive = true
    
    passwordTextFieldHeightAnchor?.isActive = false
    passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: segmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
    passwordTextFieldHeightAnchor?.isActive = true
  }
  
  // Login/Register handlers
  
  func handleLoginRegister() {
    if segmentedControl.selectedSegmentIndex == 0 {
      handleLogin()
    } else {
      handleRegister()
    }
  }
  
  func handleLogin() {
    guard let email = emailTextField.text, let password = passwordTextField.text else {
      print("Form is not valid. Please enter your email and password.")
      return
    }
    FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, err) in
      if err != nil {
        print(err ?? "Error:")
        return
      }
      print("User Login successful")
      
      // Add a pause to prevent visibility of a previously logged in users messages and info.
      let when = DispatchTime.now() + 2
      DispatchQueue.main.asyncAfter(deadline: when) {
        self.dismiss(animated: true, completion: nil)
      }
    })
  }
  
  func handleRegister() {
    guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
      print("invalid email or password")
      return
    }
    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {(user: FIRUser?, error) in
      if error != nil {
        print(error ?? "Error")
        return
      }
      
      // reference by user id:
      guard let uid = user?.uid else { return }
      
      //successfully authenticated user
      let ref = FIRDatabase.database().reference()
      let usersReference = ref.child("users").child(uid)
      let values = ["name": name, "email": email]
      usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
        if err != nil {
          print(err ?? "Error")
          return
        }
        print("Successfully saved new user into Firebase DB.")
        self.dismiss(animated: true, completion: nil)
      })
      
      print("Authenticated User")
    })
  }
}
