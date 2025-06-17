//
//  AlertManager.swift
//  movieApp
//
//  Created by özge kurnaz on 18.06.2025.
//

import UIKit

class AlertManager{
    
    private static func showBasicAlert(on vc: UIViewController,  title: String, message: String?){

        
        DispatchQueue.main.async{
            
            let alert = UIAlertController(title: title, message:message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            
            vc.present(alert, animated: true)
        }
    }
     
}


// MARK: - Show Validation Alerts
extension AlertManager{
    
    public static func showInvalidEmailAlert(on vc: UIViewController){
        self.showBasicAlert(on: vc, title: "Invalid Email", message: "Please enter a valid email.")
    }
    
    public static func showInvalidPasswordAlert(on vc: UIViewController){
        self.showBasicAlert(on: vc, title: "Invalid Password", message: "Please enter a valid password.")
    }
    
    public static func showInvalidUsernameAlert(on vc: UIViewController){
        self.showBasicAlert(on: vc, title: "Invalid Username", message: "Please enter a valid username.")
    }
    
    
}

// MARK: - Registration Errors
extension AlertManager{
    
    public static func showRegistrationErrorAlert(on vc: UIViewController){
        self.showBasicAlert(on: vc, title: "Unknown Registration Error", message: nil )
    }
    
    public static func showRegistrationErrorAlert(on vc: UIViewController, with error: Error){
        self.showBasicAlert(on: vc, title: "Unknown Registration Error", message:
            "\(error.localizedDescription)" )
    }
    

}

// MARK: - Log in Errors
extension AlertManager{
    
    public static func showLogInErrorAlert(on vc: UIViewController){
        self.showBasicAlert(on: vc, title: "Signing In Error", message: nil )
    }
    
    public static func showLogInErrorAlert(on vc: UIViewController, with error: Error){
        self.showBasicAlert(on: vc, title: "Signing In Error", message:
            "\(error.localizedDescription)" )
    }
}

// MARK: - Logout Errors
extension AlertManager{
    
    public static func showLogoutErrorAlert(on vc: UIViewController){
        self.showBasicAlert(on: vc, title: "Log out Error", message: nil )
    }
    
    public static func showLogoutErrorAlert(on vc: UIViewController, with error: Error){
        self.showBasicAlert(on: vc, title: "Log out Error", message:
            "\(error.localizedDescription)" )
    }
}

// MARK: - Forgot Password
extension AlertManager{
    
    public static func showPasswordResetSent(on vc: UIViewController){
        self.showBasicAlert(on: vc, title: "Password Reset Sent", message: nil )
    }
    
    public static func showErrorSendingPasswordReset(on vc: UIViewController, with error: Error){
        self.showBasicAlert(on: vc, title: "Error Sending Password Reset", message:
            "\(error.localizedDescription)" )
    }
}

// MARK: - Fetching User Errors
extension AlertManager{
    
    public static func showFetchingUserError(on vc: UIViewController, with error: Error){
        self.showBasicAlert(on: vc, title: "Error Fetching User", message:
            "\(error.localizedDescription)" )
    }
    
    public static func showUnknownFetchingUserError(on vc: UIViewController){
        self.showBasicAlert(on: vc, title: "Unknown Error Fetching User", message: nil)
    }
}
