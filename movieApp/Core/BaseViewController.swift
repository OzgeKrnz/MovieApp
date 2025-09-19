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
