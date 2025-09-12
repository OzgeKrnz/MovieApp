//
//  EditProfileViewModel.swift
//  movieApp
//
//  Created by özge kurnaz on 11.08.2025.
//


import UIKit
import CoreData
import FirebaseAuth


enum EditProfileState: Equatable {
    case idle
    case loading
    case success(String)
    case error(String)
}


protocol EditProfileServicing{
    func fetchCurrentUser(completion: @escaping(Result<(username:String?, email: String?),Error>)->Void)
    func updateDisplayName(_ name: String, completion: @escaping (Result<Void, Error>)->Void)
    func updatePassword(email:String, currentPassword: String, newPassword: String, completion: @escaping (Result<Void, Error>)->Void)
    
}


class EditProfileService: EditProfileServicing{

    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext){
        self.context = context
    }
    
    func fetchCurrentUser(completion: @escaping (Result<(username: String?, email: String?), any Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "Auth", code: 401, userInfo:  [NSLocalizedDescriptionKey: "No active user"])))
            return
        }
        
        let email = Auth.auth().currentUser?.email
        
        let fetch: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetch.fetchLimit = 1
        fetch.predicate = NSPredicate(format: "userUID == %@", uid)
        
        do {
            let found = try context.fetch(fetch).first
            completion(.success((username: found?.username, email: email)))
        }catch{
            completion(.failure(error))
        }
    }
    func updateDisplayName(_ name: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "Auth", code: 401, userInfo:  [NSLocalizedDescriptionKey: "No active user"])))
            return
        }
        
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        changeRequest.commitChanges{ [weak self] err in
            if let err = err {completion(.failure(err)); return}
            
            
            guard let self = self, let uid = Auth.auth().currentUser?.uid else {
                completion(.success(()))
                return
            }
            
            let fetch: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            fetch.fetchLimit = 1
            fetch.predicate = NSPredicate(format: "userUID == %@", uid)
            
            do {
                if let entity = try self.context.fetch(fetch).first{
                    entity.username = name
                    try self.context.save()
                }
                completion(.success(()))
            }catch{
                completion(.failure(error))
            }

        }
    }
    
    
    
    func updatePassword(email: String, currentPassword: String, newPassword: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "Auth", code: 401, userInfo:  [NSLocalizedDescriptionKey: "No active user"])))
            return
        }
        
        user.reauthenticate(with: credential){ _, reauthErr in
            if let reatuhErr = reauthErr { completion(.failure(reatuhErr)); return}
            user.updatePassword(to: newPassword){err in
                if let err = err { completion(.failure(err));return}
                completion(.success(()))
            }
            
        }
        
    }
    
}


class EditProfileViewModel{
       var username: String = ""
       var currentPassword: String = ""
       var newPassword: String = ""
       var confirmPassword: String = ""

       
       var onStateChange: ((EditProfileState) -> Void)?

       
       private let service: EditProfileServicing

       init(service: EditProfileServicing) {
           self.service = service
       }

       // MARK: - Public API

       func loadCurrentUser() {
           onStateChange?(.loading)
           service.fetchCurrentUser { [weak self] result in
               guard let self = self else { return }
               switch result {
               case .success(let data):
                   self.username = data.username ?? ""
                   // email UI’da gösterilecekse VC içinden ayrıca setlenebilir
                   self.onStateChange?(.success("Loaded"))
               case .failure(let error):
                   self.onStateChange?(.error(self.humanize(error)))
               }
           }
       }

       func saveProfile() {
           // E-posta değişmiyor; sadece kullanıcı adı (displayName) güncelleniyor.
           guard validateName() else { return }
           onStateChange?(.loading)
           service.updateDisplayName(username) { [weak self] result in
               guard let self = self else { return }
               switch result {
               case .success:
                   self.onStateChange?(.success("Profile updated"))
               case .failure(let error):
                   self.onStateChange?(.error(self.humanize(error)))
               }
           }
       }

       func changePassword(userEmail: String) {
           // Şifre değişimi UI’da ayrı "Kaydet" butonuna bağlı olabilir.
           // Doğrulamalar:
           guard validatePasswordFields() else { return }
           onStateChange?(.loading)
           service.updatePassword(email: userEmail, currentPassword: currentPassword, newPassword: newPassword) { [weak self] result in
               guard let self = self else { return }
               switch result {
               case .success:
                   self.currentPassword = ""
                   self.newPassword = ""
                   self.confirmPassword = ""
                   self.onStateChange?(.success("Password changed"))
               case .failure(let error):
                   self.onStateChange?(.error(self.humanize(error)))
               }
           }
       }

       // MARK: - Validation

       func validateName() -> Bool {
           if username.trimmingCharacters(in: .whitespacesAndNewlines).count < 2 {
               onStateChange?(.error("Username must be at least 2 characters."))
               return false
           }
           return true
       }

       func validatePasswordFields() -> Bool {
           if newPassword.count < 6 {
               onStateChange?(.error("New password must be at least 6 characters."))
               return false
           }
           if newPassword != confirmPassword {
               onStateChange?(.error("Passwords do not match."))
               return false
           }
           if currentPassword.isEmpty {
               onStateChange?(.error("Current password is required."))
               return false
           }
           return true
       }

       // MARK: - Helpers
       private func humanize(_ error: Error) -> String {
           // İstersen buraya Firebase hata kodu çevirisi yazabiliriz.
           return (error as NSError).localizedDescription
       }
   }
