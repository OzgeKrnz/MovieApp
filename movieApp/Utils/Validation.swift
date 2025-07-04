//
//  Validation.swift
//  movieApp
//
//  Created by özge kurnaz on 18.06.2025.
//

import Foundation

class Validation{
    static func isValidEmail(for email: String)->Bool{
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.{1}[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return emailPred.evaluate(with: email)
    }
    
    static func isValidUsername(for username: String)->Bool{
        let username = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let usernameRegex = "\\w{4,24}"
        let usernamePred = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        
        return usernamePred.evaluate(with: username)
        
    }
    
    static func isPasswordValid(for password: String)->Bool{
        let password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordRegex =  "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+\\-=\\[\\]{}\\|;:'\",.<>/?`~]).{6,32}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        print(passwordPred.evaluate(with: password))
        return passwordPred.evaluate(with: password)
        
    }    
}
