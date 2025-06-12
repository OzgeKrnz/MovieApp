//
//  CustomTextField.swift
//  movieApp
//
//  Created by özge kurnaz on 11.06.2025.
//

import UIKit

class CustomTextField: UITextField {

    enum CustomTextFieldType{
        case username
        case email
        case password
    }
    
    private let authFieldType: CustomTextFieldType
    
    init(fieldType: CustomTextFieldType){
        self.authFieldType = fieldType
        super.init(frame: .zero)
        
        self.layer.cornerRadius = 10
        self.returnKeyType = .done
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.backgroundColor = UIColor(red: 234/255, green: 239/255, blue: 239/255, alpha: 1.0)
        self.borderStyle = .roundedRect
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
}
