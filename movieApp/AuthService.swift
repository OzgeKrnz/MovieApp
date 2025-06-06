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
    
    
}
