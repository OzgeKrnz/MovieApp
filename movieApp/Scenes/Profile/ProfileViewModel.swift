//
//  ProfileViewModel.swift
//  movieApp
//
//  Created by özge kurnaz on 30.07.2025.
//

import Foundation
import UIKit


class ProfileViewModel{
    
    enum MenuItems: Int, CaseIterable{
        case editProfile
        case watchlist
        case favoriteMovies
        case languages
        
        var title: String {
                   switch self {
                   case .editProfile: return "Profil Düzenle"
                   case .watchlist: return "İzleme Listesi"
                   case .favoriteMovies: return "Favori Filmler"
                   case .languages: return "Dil"
                   }
               }
               
        var iconName: String {
            switch self {
            case .editProfile: return "pencil.line"
            case .watchlist: return "bookmark"
            case .favoriteMovies: return "heart"
            case .languages: return "globe"
            }
        }
        
        var iconColor: UIColor{
            switch self {
            case .languages: return UIColor.green
            case .favoriteMovies: return UIColor.red
            default: return UIColor.systemBlue
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
