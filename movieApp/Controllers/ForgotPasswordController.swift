//
//  ForgotPasswordController.swift
//  movieApp
//
//  Created by özge kurnaz on 7.06.2025.
//

import UIKit

class ForgotPasswordController: UIViewController {
    
        
    //MARK: - UI Components
    //header

    private let emailField = CustomTextField(fieldType: .email)
    
    private let resetPasswordButton = CustomButton(title: "Sign Up", hasBackground: true,fontSize: .big)
    
    let imageView = UIImageView()

    
    //MARK: - LyfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        setupUI()
        self.resetPasswordButton.addTarget(self, action: #selector(didTapResetPasswordButton), for: .touchUpInside)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    //MARK: - UI Setup
    
    private func setupImageView(){
        imageView.image = UIImage(named: "backgroundImg")
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
        self.emailField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(emailField)
        
        self.resetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(resetPasswordButton)
        
        
        NSLayoutConstraint.activate([
            self.emailField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
            self.emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.emailField.heightAnchor.constraint(equalToConstant: 45),
            self.emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.resetPasswordButton.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 12),
            self.resetPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.resetPasswordButton.heightAnchor.constraint(equalToConstant: 45),
            self.resetPasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
        
        
        ])
    }

    
    //MARK: - Selectors
    
    
    @objc private func didTapResetPasswordButton(){
        let email = self.emailField.text ?? ""
        
        
        
        //Email check
        if !Validation.isValidEmail(for: email){
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        
        AuthService.shared.forgotPassword(with: email){ [weak self]  error in
            guard let self = self else {return}
            if let error = error{
                AlertManager.showErrorSendingPasswordReset(on: self, with: error)
                return
            }
            
            AlertManager.showPasswordResetSent(on: self)
            
        }
        
    }


}
