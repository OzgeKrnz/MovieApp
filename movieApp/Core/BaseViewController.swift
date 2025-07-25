//
//  BaseViewController.swift
//  movieApp
//
//  Created by özge kurnaz on 19.05.2025.
//

import UIKit

class BaseViewController: UIViewController{
    
    let customToolbar = CustomToolbar()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 39/255, green: 63/255, blue: 79/255, alpha: 1)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Log out", style: .plain, target: self,
            action: #selector(didTapLogOutButton))

        setupToolbar()
        setupToolbarActions()
    }
    
    func hiddenKeyboardWhenTappedAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    
    private func setupToolbar() {
        view.addSubview(customToolbar)
        customToolbar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customToolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customToolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customToolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            customToolbar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupToolbarActions() {
        customToolbar.onHomeTapped = { [weak self] in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = storyboard.instantiateViewController(identifier: "MainVC") as! ViewController
            self?.navigationController?.setViewControllers([homeVC], animated: true)
        }
   
        
        customToolbar.onFavoritesTapped = { [weak self] in
            let storyboard = UIStoryboard(name:"Main", bundle:nil)
            let favoritesVC = storyboard.instantiateViewController(identifier: "Favorites") as! FavoritesViewController
            self?.navigationController?.setViewControllers([favoritesVC], animated: true)
        }
        
        customToolbar.onProfileTapped = { [weak self] in
            
            let storyboard = UIStoryboard(name:"Main", bundle:nil)
            let profileVC = storyboard.instantiateViewController(identifier: "Profile") as! ProfileViewController
            self?.navigationController?.setViewControllers([profileVC], animated: true)
        }
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
