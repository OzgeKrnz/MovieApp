//
//  AuthService.swift
//  movieApp
//
//  Created by özge kurnaz on 6.06.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService{
    
    
    public static let shared = AuthService()
    
    private init(){}
    
    
    
    /// A method to register the user
    /// - Parameters:
    ///   - userRequest: The users information - email, password, username
    ///   - completion: A completion with two values
    ///   - Bool: was registered - Determines if the user was registered and saved the databas correctly
    ///   - Error?: Am optional error if Firebase provides once
    public func registerUser(with userRequest: RegisterUserRequest,
                             completion: @escaping (Bool, Error?)->Void){
        let username = userRequest.username
        let email = userRequest.email
        let password = userRequest.password
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error)
                return
            }
            guard let resultUser = result?.user else{
                completion(false, nil)
                return
            }
            
            let db = Firestore.firestore()
            
            // users is the first collection
            db.collection("users")
                .document(resultUser.uid)
                .setData([
                    "username":username,
                    "email":email,
                ]) { error in
                    if let error = error {
                        completion(false, error)
                        return
                    }
                    completion(true, nil)
                }
        }

    }
    
    public func signIn(with userRequest: LoginUserRequest, completion: @escaping (Error?)->Void){
        Auth.auth().signIn(withEmail: userRequest.email, password: userRequest.password) { result, error in
            if let error = error {
                completion(error)
                return
            } else{
                completion(nil)
            }
        }
    }
    
    public func signOut(completion: @escaping (Error?)->Void){
        do{
            try Auth.auth().signOut()
            completion(nil)
        }catch let error {
            completion(error)
        }
    }
    
    public func forgotPassword(with email: String, completion: @escaping (Error?)->Void){
        Auth.auth().sendPasswordReset(withEmail: email){error in
            completion(error)
        }
    }
    
    public func fetchUser(completion: @escaping(User?, Error?)->Void){
        guard let userUID = Auth.auth().currentUser?.uid else {return}
        
        let db =  Firestore.firestore()
    
        db.collection("users")
            .document(userUID)
            .getDocument { snapshot, error in
                if let error = error{
                    completion(nil, error)
                    return
                }
                
                if let snapshot = snapshot,
                   let snapshotData = snapshot.data(),
                   let username = snapshotData["username"] as? String,
                   let email = snapshotData["email"] as? String{
                    let user = User(username: username, email: email, userID: userUID)
                    completion(user, nil)
                }
            }
        print("Kullanıcı uid:",userUID)
    }
    

    
    
}
