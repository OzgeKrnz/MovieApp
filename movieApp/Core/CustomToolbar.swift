//
//  CustomToolbar.swift
//  movieApp
//
//  Created by özge kurnaz on 24.07.2025.
//

import UIKit

final class CustomToolbar: UIToolbar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var onHomeTapped: (()->Void)?
    var onFavoritesTapped: (()->Void)?
    var onProfileTapped: (()->Void)?
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupToolbar()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init coder has not been implemented")
    }
    
    
    private func setupToolbar(){
        let homeItem = UIBarButtonItem(image: UIImage(systemName: "house"), style: .plain, target: self, action: #selector(homeTapped))
        
        let favoritesItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(favoritesTapped))
        
        let profileItem = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(profileTapped))
        
        let space = UIBarButtonItem.flexibleSpace()
        
        // toolbar item sırası
        self.items = [
            homeItem,
            space,
            favoritesItem,
            space,
            profileItem
        ]
        
        self.tintColor = .orange
        self.barTintColor = UIColor(red: 39/255, green: 63/255, blue: 79/255, alpha: 1)
        self.isTranslucent = false
    }
    
    
    //MARK: - Actions
    
    @objc func homeTapped(){
        onHomeTapped?()
    }
    
    @objc func favoritesTapped(){
        onFavoritesTapped?()
    }
    
    @objc func profileTapped(){
        onProfileTapped?()
    }
    
    

}
