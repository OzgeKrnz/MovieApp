//
//  FavoriteMoviesViewModel.swift
//  movieApp
//
//  Created by özge kurnaz on 28.07.2025.
//

import Foundation
import CoreData
import FirebaseAuth

class FavoriteMoviesViewModel {
    
    
    var favoriteMovies:[ Movie] = []
    
    func fetchFavoriteMovies(){
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Kullanıcı giriş yapmamış")
            favoriteMovies = []

            return
        }
        
        let context = PersistenceController.shared.context
        let fetchRequest: NSFetchRequest<CDMovieEntity> = CDMovieEntity.fetchRequest()
        
        
        fetchRequest.predicate = NSPredicate(format: "userUID == %@ AND isLiked == YES", uid)
        fetchRequest.returnsObjectsAsFaults = false


        do {
            let results = try context.fetch(fetchRequest)
            
            self.favoriteMovies = results.map { entity in
                     Movie(
                         title: entity.title ?? "",
                         overview: entity.overview ?? "",
                         genres: nil,
                         id: Int(entity.movieID),
                         posterPath: entity.posterPath
                     )
                 }
            
            print("favorite movies: \(results.count)")
        } catch {
            print("CoreData fetch hatası: \(error)")
            favoriteMovies = []

        }
    }
    
    func movie(at index: Int)-> Movie{
        return favoriteMovies[index]
    }
    
    func numberOfMovies()->Int{
        return favoriteMovies.count
    }
}
