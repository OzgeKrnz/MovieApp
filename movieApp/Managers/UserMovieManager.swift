//
//  UserMovieManager.swift
//  movieApp
//
//  Created by özge kurnaz on 4.07.2025.
//

import FirebaseAuth
import CoreData
import UIKit


class UserMovieManager{
    static let shared = UserMovieManager()
    
    enum MovieStatus: String, CaseIterable{
        case watched = "Watched"
        case liked = "Liked"
        case rated = "Rated"
        
        
        var iconName: String {
            switch self {
            case .watched: return "eye.fill"
            case .liked: return "heart.fill"
            case .rated: return "star.fill"
                
            }
        }
    }
    
    func saveUserMovie(movie: Movie, status: String? = nil, rating: Double? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Kullanıcı giriş yapmamış")
            return
        }

        let context = PersistenceController.shared.context

        // Varsa güncelle
        let fetchRequest: NSFetchRequest<CDMovieEntity> = CDMovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "movieID == %lld AND userUID == %@", Int64(movie.id), uid)

        if let existing = try? context.fetch(fetchRequest).first {
            if let status = status {
                existing.status = status
            }
            
            if let rating = rating {
                existing.userRating = Float(rating)
            }
            
        } else {
            let userMovie = CDMovieEntity(context: context)
            userMovie.userUID = uid
            userMovie.movieID = Int64(movie.id)
            userMovie.status = status
            if let rating = rating{
                userMovie.userRating = Float(rating)
            }
            userMovie.overview = movie.overview
            userMovie.title = movie.title
            userMovie.posterPath = movie.poster_path
        }

        do {
            try context.save()
            print("Film kaydedildi/güncellendi.")
        } catch {
            print("Core Data hatası:", error)
        }
    }

    
    func getStatus(for movieId: Int64, userId: String)->String? {
        let context = PersistenceController.shared.context

        let fetchRequest : NSFetchRequest<CDMovieEntity> = CDMovieEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "movieID ==  %lld AND userUID == %@", movieId, userId)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first?.status
        }catch{
            print("status fetch failed", error)
            return nil
        }
    }
    
    func getRating(for movieId: Int64, userId: String)->Float? {
        let context = PersistenceController.shared.context

        let fetchRequest : NSFetchRequest<CDMovieEntity> = CDMovieEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "movieID ==  %lld AND userUID == %@", movieId, userId)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first?.userRating
        }catch{
            print("status fetch failed", error)
            return nil
        }
    }
    
    
    
    
    
}
