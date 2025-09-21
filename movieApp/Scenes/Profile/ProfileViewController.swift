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

class ProfileViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    

    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        

        setupUI()
        fetchUserInfo()

    }
    

    private func setupUI(){
        profileIcon.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        usernameLabel.textColor = .white
        emailLabel.textColor = .white

        profileIcon.tintColor = UIColor.white.withAlphaComponent(0.9)

      
        tableView.backgroundColor = .clear
        tableView.separatorColor = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 72
        
   
        
        
        NSLayoutConstraint.activate([
            profileIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileIcon.widthAnchor.constraint(equalToConstant: 100),
            profileIcon.heightAnchor.constraint(equalToConstant: 100),
            profileIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: profileIcon.bottomAnchor, constant: 4),
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emailLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
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
                usernameLabel.text = usernameLabel.text?.uppercased()
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
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileViewCell", for: indexPath) as? ProfileViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        
        let item = viewModel.item(at: indexPath.row)
        cell.configure(title: item.title, iconName: item.iconName, iconColor: item.iconColor)
        cell.selectionStyle = .gray
        
    
        return cell
    }
    
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = viewModel.item(at: indexPath.row)
        
        switch selectedItem {
        case .editProfile:
            pushEditProfile()
        case .watchlist:
            pushWatchlist()
        case .favoriteMovies:
            pushFavoriteMovies()
        case .languages:
            presentLanguagePicker()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    private func pushEditProfile() {
        guard let app = UIApplication.shared.delegate as? AppDelegate else { return }
        let ctx = app.persistentContainer.viewContext
        let vm = EditProfileViewModel(service: EditProfileService(context: ctx))

        let vc = EditProfileViewController()
        vc.editProfileViewModel = vm
        navigationController?.pushViewController(vc, animated: true)
    }

    private func pushWatchlist() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Planned") as? WatchlistViewController {
            navigationController?.pushViewController(vc, animated: true)
        } else {
            navigationController?.pushViewController(WatchlistViewController(), animated: true)
        }
    }

    private func pushFavoriteMovies() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Favorites") as? FavoritesViewController {
            navigationController?.pushViewController(vc, animated: true)
        } else {
            navigationController?.pushViewController(FavoritesViewController(), animated: true)
        }
    }
    
    
    private func presentLanguagePicker() {
        let alert = UIAlertController(title: "Dil", message: "", preferredStyle: .actionSheet)

        let apply: (String) -> Void = { code in
            UserDefaults.standard.set(code, forKey: "app_language_code")

            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            self.presentedViewController?.dismiss(animated: true)
            let info = UIAlertController(title: "Restart Required", message: "Language will apply after restart.", preferredStyle: .alert)
            info.addAction(ok)
            self.present(info, animated: true)
        }

        alert.addAction(UIAlertAction(title: "English", style: .default, handler: { _ in apply("en") }))
        alert.addAction(UIAlertAction(title: "Türkçe", style: .default, handler: { _ in apply("tr") }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }

    private func confirmAndSignOut() {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
            self.performSignOut()
        }))
        present(alert, animated: true)
    }

    private func performSignOut() {
        // 1) Firebase SignOut
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign out failed: \(error)")
            let errA = UIAlertController(title: "Error", message: "Could not sign out. Try again.", preferredStyle: .alert)
            errA.addAction(UIAlertAction(title: "OK", style: .default))
            present(errA, animated: true)
            return
        }

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetch: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
     
        fetch.includesPropertyValues = false
        do {
            let all = try context.fetch(fetch)
            for obj in all { context.delete(obj) }
            try context.save()
        } catch {
            print("Core Data cleanup failed: \(error)")
        }

    
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let delegate = scene.delegate as? SceneDelegate,
            let window = delegate.window {
             let sb = UIStoryboard(name: "Main", bundle: nil)
             let login = sb.instantiateViewController(withIdentifier: "LoginVC")
             window.rootViewController = UINavigationController(rootViewController: login)
             window.makeKeyAndVisible()
         } else {
             navigationController?.popToRootViewController(animated: true)
         }
    }


}
