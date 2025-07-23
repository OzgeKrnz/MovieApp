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
          print("favorites tapped")
        }
        
        customToolbar.onProfileTapped = { [weak self] in
        print("profile tapped")
        }
    }
}
