//
//  LoginViewController.swift
//  movieApp
//
//  Created by özge kurnaz on 4.06.2025.
//

import UIKit

class LoginViewController: UIViewController {

    private let usernameField = CustomTextField(fieldType: .username)
    private let passwordField = CustomTextField(fieldType: .password)
    private let signInButton = CustomButton(title: "Sign In", hasBackground: true, fontSize: .med)
    
    let imageView = UIImageView()
   

    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupImageView()
        self.setupUI()
        
    }
    
    // MARK: - Setup UI
    private func setupImageView(){
        imageView.image = UIImage(named: "loginBackgroundImg")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo:  view.bottomAnchor),
        ])
    }
    
    private func setupUI(){
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(usernameField)
        //self.view.bringSubviewToFront(usernameField)
        
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(passwordField)
        // self.view.bringSubviewToFront(passwordField)
        
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(signInButton)
        //self.view.bringSubviewToFront(signInButton)
        
        
        NSLayoutConstraint.activate([
            usernameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 240),
            usernameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameField.heightAnchor.constraint(equalToConstant: 45),
            usernameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            
            passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 8),
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 45),
            passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            signInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 8),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 45),
            signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
        ])
      
    }
    
    
    
}
