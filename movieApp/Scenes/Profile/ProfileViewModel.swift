//
//  ProfileViewModel.swift
//  movieApp
//
//  Created by özge kurnaz on 30.07.2025.
//

import Foundation


class ProfileViewModel{
    
    enum MenuItems: Int, CaseIterable{
        case editProfile
        case watchlist
        case favoriteMovies
        case languages
        case signOut
        
        var title: String {
                   switch self {
                   case .editProfile: return "Edit Profile"
                   case .watchlist: return "Watchlist"
                   case .favoriteMovies: return "Favorite Movies"
                   case .languages: return "Languages"
                   case .signOut: return "Sign Out"
                   }
               }
               
        var iconName: String {
            switch self {
            case .editProfile: return "person.crop.circle"
            case .watchlist: return "bookmark"
            case .favoriteMovies: return "heart"
            case .languages: return "globe"
            case .signOut: return "arrow.left.square"
            }
        }
        
        
    }
     
    func numberOfItems() -> Int {
        return MenuItems.allCases.count
    }
    
    func item(at index: Int) -> MenuItems {
        return MenuItems(rawValue: index)!
    }
    
    
}
