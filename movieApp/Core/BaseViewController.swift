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
            self?.setRootIfNeeded(
                targetType: ViewController.self,
                storyboardID: "MainVC",
                scrollToTop: { home in
                    home.collectionView.setContentOffset(.zero, animated: true)
                }
            )
        }

        customToolbar.onFavoritesTapped = { [weak self] in
            self?.setRootIfNeeded(
                targetType: FavoritesViewController.self,
                storyboardID: "Favorites",
                scrollToTop: { fav in
                    fav.collectionView.setContentOffset(.zero, animated: true)
                }
            )
        }

        customToolbar.onProfileTapped = { [weak self] in
            self?.setRootIfNeeded(
                targetType: ProfileViewController.self,
                storyboardID: "Profile",
                scrollToTop: { _ in  }
            )
        }
    }
    
    private func setRootIfNeeded<T: UIViewController>(
        targetType: T.Type,
        storyboardID: String,
        scrollToTop: ((T) -> Void)? = nil
    ) {
        guard let nav = self.navigationController else { return }

        if let root = nav.viewControllers.first as? T {
            scrollToTop?(root)
            return
        }

        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: storyboardID) as? T else {
            assertionFailure("Storyboard ID '\(storyboardID)' \(T.self) ile eşleşmiyor.")
            return
        }
        nav.setViewControllers([vc], animated: true)
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
