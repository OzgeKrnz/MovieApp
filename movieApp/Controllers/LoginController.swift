//
//  LoginViewController.swift
//  movieApp
//
//  Created by özge kurnaz on 4.06.2025.
//

import UIKit

class LoginController: ViewController {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var buttonItem: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        buttonItem.translatesAutoresizingMaskIntoConstraints = false
        
        emailTextField.clipsToBounds = true
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            buttonItem.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50),
            buttonItem.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonItem.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        
            
  
            
        ])
    }
    
}
