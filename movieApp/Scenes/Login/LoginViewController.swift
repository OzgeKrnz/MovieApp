//
//  LoginViewController.swift
//  movieApp
//
//  Created by özge kurnaz on 4.06.2025.
//

import UIKit
import CoreData
import FirebaseAuth

class LoginViewController: UIViewController {

    private let emailField = CustomTextField(fieldType: .email)
    private let passwordField = CustomTextField(fieldType: .password)
    
    private let signInButton = CustomButton(title: "Sign In", hasBackground: true, fontSize: .big)
    private let newUserButton = CustomButton(title: "New User? Create Account.", fontSize: .med)
    private let forgotPasswordButton = CustomButton(title: "Forgot Password?", fontSize: .small)
    
    
    let imageView = UIImageView()
   

    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupImageView()
        self.setupUI()
        
        self.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        self.newUserButton.addTarget(self, action: #selector(didTapNewUser), for: .touchUpInside)
        self.forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)

        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        emailField.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(emailField)
        //self.view.bringSubviewToFront(usernameField)
        
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(passwordField)
        // self.view.bringSubviewToFront(passwordField)
        
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(signInButton)
        //self.view.bringSubviewToFront(signInButton)
        
        newUserButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(newUserButton)
        
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(forgotPasswordButton)

        NSLayoutConstraint.activate([
            emailField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 240),
            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.heightAnchor.constraint(equalToConstant: 45),
            emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 8),
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 45),
            passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            signInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 8),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 45),
            signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            newUserButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 8),
            newUserButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newUserButton.heightAnchor.constraint(equalToConstant: 44),
            newUserButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: newUserButton.bottomAnchor, constant: 4),
            forgotPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: 44),
            forgotPasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
        ])
      
    }
    
    // MARK: - Selectors
    @objc private func didTapSignIn(){
        
        let loginReq = LoginUserRequest(
            email: self.emailField.text ?? "",
            password: self.passwordField.text ?? ""
        )
          

        //Email check
        if !Validation.isValidEmail(for: loginReq.email){
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
    
        //Password check
        if !Validation.isPasswordValid(for: loginReq.password){
            AlertManager.showInvalidPasswordAlert(on: self)
            return
        }
        
        AuthService.shared.signIn(with: loginReq){ [weak self] error in
            guard let self = self else {return }
            if let error = error {
                AlertManager.showLogInErrorAlert(on: self, with: error)
                return
            }
            
            if let user = Auth.auth().currentUser{
                self.fetchUserFromCoreData(uid: user.uid)
            }
            
            if let sceneDelegate = self.view.window?.windowScene?.delegate as?
                SceneDelegate{
                sceneDelegate.checkAuthentication()
            } else{
                AlertManager.showLogInErrorAlert(on: self)
            }
 
            
        }
      /*  let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "MainVC") as! ViewController
        let navController = UINavigationController(rootViewController: VC)
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = scene.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = navController
        }*/
        
        
    }
    
    @objc private func didTapNewUser(){
        let vc = RegisterController()
        self.navigationController?.pushViewController(vc, animated: true)
        print("newuser")

    }
    
    @objc private func didTapForgotPassword(){
        let vc = ForgotPasswordController()
        self.navigationController?.pushViewController(vc, animated: true)
        

    }
    
    private func fetchUserFromCoreData(uid: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userUID == %@", uid)
        
        do {
            if let user = try context.fetch(fetchRequest).first {
                print("Kullanıcı bulundu: \(user.username ?? "") - \(user.email ?? "")")
            } else {
                print("Core Data’da kullanıcı bulunamadı → yeni cihaz olabilir")
            }
        } catch {
            print("Core Data fetch hatası: \(error)")
        }
    }

}
