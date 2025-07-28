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

class ProfileViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    
    
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var menuItems : [[ProfileMenuItem]] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        fetchUserInfo()
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    
    private func setupData(){
        let section = [
            ProfileMenuItem(title: "Edit Profile", iconName: "pen"),
            ProfileMenuItem(title: "Favorites", iconName: "heart"),
            ProfileMenuItem(title: "Languages", iconName: "globe"),
            ProfileMenuItem(title: "Sign Out", iconName: "arrow.left.square" )
            
            ]
        
        menuItems = [section]
       
    }
    
    
    private func setupUI(){
        profileIcon.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        usernameLabel.textColor = .white
        emailLabel.textColor = .white
        
        tableView.backgroundColor = .clear
        tableView.separatorColor = .gray
        
        
        NSLayoutConstraint.activate([
            profileIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileIcon.widthAnchor.constraint(equalToConstant: 80),
            profileIcon.heightAnchor.constraint(equalToConstant: 80),
            
            usernameLabel.topAnchor.constraint(equalTo: profileIcon.topAnchor, constant: 4),
            usernameLabel.leadingAnchor.constraint(equalTo: profileIcon.trailingAnchor, constant: 20),
            
            emailLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            
            tableView.topAnchor.constraint(equalTo: profileIcon.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileViewCell", for:indexPath ) as? ProfileViewCell else{return UITableViewCell()}
        
        let item = menuItems[indexPath.section][indexPath.row]
        
        cell.configure(with: item)
        
        // ok ekleme
        cell.accessoryType = .disclosureIndicator
        
        cell.backgroundColor = UIColor(red: 39/255, green: 63/255, blue: 79/255, alpha: 1)
        cell.selectionStyle = .gray
         
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
}
