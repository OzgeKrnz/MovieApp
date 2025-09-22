//
//  BaseViewController.swift
//  movieApp
//
//  Created by özge kurnaz on 19.05.2025.
//

import UIKit

class BaseViewController: UIViewController{
    
 

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 39/255, green: 63/255, blue: 79/255, alpha: 1)
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Çıkış Yap", style: .plain, target: self,
            action: #selector(didTapLogOutButton))
    }
    
    func hiddenKeyboardWhenTappedAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func setupGradientBackground(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 27/255, green: 42/255, blue: 54/255, alpha: 1).cgColor, // üst
            UIColor(red: 39/255, green: 63/255, blue: 79/255, alpha: 1).cgColor  // alt
        ]
        gradientLayer.locations = [0.0, 1.0] // yukarıdan aşağıya
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = view.bounds

        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    

    
    @objc func didTapLogOutButton() {
        AuthService.shared.signOut { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showLogoutErrorAlert(on: self, with: error)
                return
            }

            if let sceneDelegate = self.view.window?.windowScene?.delegate
                as? SceneDelegate
            {
                sceneDelegate.checkAuthentication()
            }
        }
    }
}
