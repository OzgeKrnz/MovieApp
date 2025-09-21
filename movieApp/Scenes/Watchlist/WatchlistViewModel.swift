//
//  WatchlistViewModel.swift
//  movieApp
//
//  Created by özge kurnaz on 11.09.2025.
//

import Foundation
import CoreData
import FirebaseAuth

class WatchlistViewModel{
    private(set) var wathchedMovies: [Movie] = []
    
    func fetchWatchedMovies() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Lütfen giriş yapın")
            wathchedMovies = []
            return
        }
        
        let context = PersistenceController.shared.context
        let request: NSFetchRequest<CDMovieEntity> = CDMovieEntity.fetchRequest()
        
        // planned
        request.predicate = NSPredicate(format: "userUID == %@ AND isWatched == YES", uid)
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            self.wathchedMovies = results.map { entity in
                     Movie(
                         title: entity.title ?? "",
                         overview: entity.overview ?? "",
                         genres: nil,
                         id: Int(entity.movieID),
                         posterPath: entity.posterPath,
                         backdropPath: entity.backdropPath,
                         voteAverage: entity.voteAverage
                     )
                 }
            
            print("added watchlist: \(results.count)")
        } catch {
            print("CoreData fetch hatası: \(error)")
            wathchedMovies = []

        }
    }
    
    func movie(at index: Int)-> Movie{
        return wathchedMovies[index]
    }
    
    func numberOfMovies()->Int{
        return wathchedMovies.count
    }
}
