//
//  ProfileViewController.swift
//  movieApp
//
//  Created by özge kurnaz on 25.07.2025.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreData

class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        fetchUserInfo()
    }
    
    
    private func setupUI(){
        profileIcon.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        usernameLabel.textColor = .white
        emailLabel.textColor = .white
        
        
        NSLayoutConstraint.activate([
            profileIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileIcon.widthAnchor.constraint(equalToConstant: 80),
            profileIcon.heightAnchor.constraint(equalToConstant: 80),
            
            usernameLabel.topAnchor.constraint(equalTo: profileIcon.topAnchor, constant: 4),
            usernameLabel.leadingAnchor.constraint(equalTo: profileIcon.trailingAnchor, constant: 20),
            
            emailLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
        ])
    }
    
    
    private func fetchUserInfo() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userUID == %@", uid)
        
        do {
            let users = try context.fetch(fetchRequest)
            if let currentUser = users.first{
                usernameLabel.text = currentUser.username
                emailLabel.text = currentUser.email
            } else {
                usernameLabel.text = "Kullanıcı yok"
                emailLabel.text = "-"
            }
        }catch {
            print("Kullanıcı cekilemedi: \(error)")
        }
    }

}
