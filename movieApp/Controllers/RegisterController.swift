//
//  RegisterController.swift
//  movieApp
//
//  Created by özge kurnaz on 6.06.2025.
//

import Foundation
import UIKit

class RegisterController: UIViewController{

    private let usernameField = CustomTextField(fieldType: .username)
    private let emailAddressField = CustomTextField(fieldType: .email)
    private let passwordField = CustomTextField(fieldType: .password)
    
    private let signUpButton = CustomButton(title: "Sign Up", hasBackground: true, fontSize: .big)
    private let signInButton = CustomButton(title: "Already have an account? Sign In.", hasBackground: false, fontSize: .med)
    
    private let termsTextView: UITextView = {
 
        let attributedString = NSMutableAttributedString(string: "By creating an account, you agree to our Terms & Conditions and you acknowledge that you have read our Privacy Policy.")
        
        attributedString.addAttribute(.link, value: "terms://termsAndConditions", range: (attributedString.string as NSString).range(of: "Terms & Conditions"))
        
        attributedString.addAttribute(.link, value: "privacy://privacyPolicy", range: (attributedString.string as NSString).range(of: "Privacy Policy"))
        
        let tv = UITextView()
        tv.linkTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.systemBlue
        ]
        
        tv.backgroundColor = .clear
        tv.attributedText = attributedString
        tv.textColor = .label
        tv.isSelectable = true
        tv.isEditable = false
        tv.delaysContentTouches = false
        tv.textColor = .white
        tv.isScrollEnabled = false
        return tv
    }()

    
    
    let imageView = UIImageView()
   

    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupImageView()
        self.setupUI()
        
        self.termsTextView.delegate = self
        
        self.signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        self.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)

        
    }
    

    // MARK: - Setup UI
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
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(usernameField)
        //self.view.bringSubviewToFront(usernameField)
        
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(passwordField)
        // self.view.bringSubviewToFront(passwordField)
        
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(signUpButton)
        //self.view.bringSubviewToFront(signInButton)
        
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(signInButton)
        
        
        emailAddressField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(emailAddressField)
        
        termsTextView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(termsTextView)
           
        NSLayoutConstraint.activate([
            usernameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 240),
            usernameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameField.heightAnchor.constraint(equalToConstant: 45),
            usernameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            emailAddressField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 8),
            emailAddressField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailAddressField.heightAnchor.constraint(equalToConstant: 45),
            emailAddressField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            passwordField.topAnchor.constraint(equalTo: emailAddressField.bottomAnchor, constant: 8),
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 45),
            passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            signUpButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 8),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 45),
            signUpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            termsTextView.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 8),
            termsTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            termsTextView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            
            signInButton.topAnchor.constraint(equalTo: termsTextView.bottomAnchor, constant: 8),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 44),
            signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            
        ])
      
    }
    
    // MARK: - Selectors
    @objc private func didTapSignUp(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "MainVC") as! ViewController
        let navController = UINavigationController(rootViewController: VC)
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = scene.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = navController
        }
   
        
  
        
    }
    
    @objc private func didTapSignIn(){
        let vc = LoginViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
 

}

extension RegisterController: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        if URL.scheme == "terms"{
            self.showWebViewerController(with: "https://policies.google.com/terms?h1=en")
        }else if URL.scheme == "privacy"{
            self.showWebViewerController(with: "https://policies.google.com/privacy?h1=en")

        }
        
        return true
    }
    
    private func showWebViewerController(with urlString: String){
        let vc = WebViewerController(with: urlString)
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }

}
