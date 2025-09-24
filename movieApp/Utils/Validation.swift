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
    
    static func isValidUsername(for username: String) -> Bool {        guard username.trimmingCharacters(in: .whitespacesAndNewlines) == username,
              !username.contains("  ") else { return false }

        // 4–24: Unicode harf + rakam + . _ + TEK boşluk
        let regex = #"^(?=.{4,24}$)[\p{L}\p{M}0-9._]+(?: [\p{L}\p{M}0-9._]+)*$"#
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: username)
    }
    
    static func isPasswordValid(for password: String)->Bool{
        let password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordRegex =  "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+\\-=\\[\\]{}\\|;:'\",.<>/?`~]).{6,32}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        print(passwordPred.evaluate(with: password))
        return passwordPred.evaluate(with: password)
        
    }    
}
