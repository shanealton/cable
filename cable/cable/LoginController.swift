//
//  LoginController.swift
//  cable
//
//  Created by Shane Alton on 6/23/17.
//  Copyright © 2017 Shane Alton. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
  
  // Header section
  
  let headerContainer: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let headerSeparator: UIView = {
    let view = UIView()
    view.backgroundColor = .rgb(red: 235, green: 232, blue: 228)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // Login/Register section
  
  let inputsContainerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // Email Input Field
  
  let emailTextField: UITextField = {
    let field = UITextField()
    field.placeholder = "Email Address"
    field.keyboardType = UIKeyboardType.emailAddress
    field.autocapitalizationType = .none
    field.translatesAutoresizingMaskIntoConstraints = false
    return field
  }()
  
  let emailSeparator: UIView = {
    let view = UIView()
    view.backgroundColor = .rgb(red: 235, green: 232, blue: 228)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // Password Fields
  
  let passwordTextField: UITextField = {
    let field = UITextField()
    field.placeholder = "Password"
    field.autocapitalizationType = .none
    field.isSecureTextEntry = true
    field.translatesAutoresizingMaskIntoConstraints = false
    return field
  }()
  
  let passwordSeparator: UIView = {
    let view = UIView()
    view.backgroundColor = .rgb(red: 235, green: 232, blue: 228)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // Confirm Password
  
  let confirmPasswordTextField: UITextField = {
    let field = UITextField()
    field.placeholder = "Confirm Password"
    field.autocapitalizationType = .none
    field.isSecureTextEntry = true
    field.translatesAutoresizingMaskIntoConstraints = false
    return field
  }()
  
  let confirmPasswordSeparator: UIView = {
    let view = UIView()
    view.backgroundColor = .rgb(red: 235, green: 232, blue: 228)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // Login/Register Button
  
  let registerButton: UIButton = {
    let button = UIButton(type: .system)
    button.backgroundColor = .rgb(red: 90, green: 97, blue: 117)
    button.layer.cornerRadius = 2
    button.setTitle("Register", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
    button.tintColor = .white
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    view.addSubview(headerContainer)
    
    view.addSubview(inputsContainerView)
    view.addSubview(registerButton)
    
    setupHeaderContainer()
    
    setupInputsContainer()
    setupRegisterButton()
  }
  
  // Header section
  
  func setupHeaderContainer() {
    headerContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    headerContainer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    headerContainer.heightAnchor.constraint(equalToConstant: 65).isActive = true
    
    headerContainer.addSubview(headerSeparator)
    
    headerSeparator.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor).isActive = true
    headerSeparator.widthAnchor.constraint(equalTo: headerContainer.widthAnchor).isActive = true
    headerSeparator.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
  }
  
  // Login/Register section
  
  func setupInputsContainer() {
    inputsContainerView.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: 16).isActive = true
    inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
    inputsContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    
    inputsContainerView.addSubview(emailTextField)
    inputsContainerView.addSubview(emailSeparator)
    
    inputsContainerView.addSubview(passwordTextField)
    inputsContainerView.addSubview(passwordSeparator)
    
    inputsContainerView.addSubview(confirmPasswordTextField)
    inputsContainerView.addSubview(confirmPasswordSeparator)
    
    setupEmailField()
    setupPasswordField()
    setupConfirmPasswordField()
  }
  
  func setupEmailField() {
    emailTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
    emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
    emailTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: -16).isActive = true
    emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
    
    emailSeparator.bottomAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
    emailSeparator.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
    emailSeparator.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
    emailSeparator.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
  }
  
  func setupPasswordField() {
    passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15).isActive = true
    passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
    passwordTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: -16).isActive = true
    passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
    
    passwordSeparator.bottomAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
    passwordSeparator.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
    passwordSeparator.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
    passwordSeparator.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
  }
  
  func setupConfirmPasswordField() {
    confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15).isActive = true
    confirmPasswordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 16).isActive = true
    confirmPasswordTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: -16).isActive = true
    confirmPasswordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
    
    confirmPasswordSeparator.bottomAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor).isActive = true
    confirmPasswordSeparator.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
    confirmPasswordSeparator.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
    confirmPasswordSeparator.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
  }
  
  func setupRegisterButton() {
    registerButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 56).isActive = true
    registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    registerButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
    registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
  }
}
