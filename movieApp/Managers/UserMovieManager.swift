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
    
    
    //MARK: - Save or udate
    func saveUserMovie(movie: Movie, status: String? = nil, rating: Double? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Kullanıcı giriş yapmamış")
            return
        }

        let context = PersistenceController.shared.context

        let fetchRequest: NSFetchRequest<CDMovieEntity> = CDMovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "movieID == %lld AND userUID == %@", Int64(movie.id), uid)

        let entity = (try? context.fetch(fetchRequest).first) ?? CDMovieEntity(context: context)

        entity.userUID = uid
        entity.movieID = Int64(movie.id)
        entity.title = movie.title
        entity.posterPath = movie.posterPath
        entity.overview = movie.overview
        entity.backdropPath = movie.backdropPath
        entity.voteAverage = movie.voteAverage ?? 0.0

        if let status = status {
            switch status {
            case MovieStatus.watched.rawValue:
                entity.isWatched.toggle()
            case MovieStatus.liked.rawValue:
                entity.isLiked.toggle()
            case MovieStatus.rated.rawValue:
                entity.isRated = true
            default:
                break
            }
        }

        if let rating = rating {
            entity.userRating = Float(rating)
            entity.isRated = true
        }

        do {
            try context.save()
            print("Film kaydedildi/güncellendi.")
        } catch {
            print("Core Data hatası:", error)
        }
    }


    //MARK: - Get rating
    func getRating(for movieId: Int64, userId: String) -> Float? {
           return fetchEntity(for: movieId, userId: userId)?.userRating
       }

       // MARK: - Get Boolean Statuses
       func getIsWatched(for movieId: Int64, userId: String) -> Bool {
           return fetchEntity(for: movieId, userId: userId)?.isWatched ?? false
       }

       func getIsLiked(for movieId: Int64, userId: String) -> Bool {
           return fetchEntity(for: movieId, userId: userId)?.isLiked ?? false
       }

       func getIsRated(for movieId: Int64, userId: String) -> Bool {
           return fetchEntity(for: movieId, userId: userId)?.isRated ?? false
       }

       // MARK: - Fetch Entity Helper
       private func fetchEntity(for movieId: Int64, userId: String) -> CDMovieEntity? {
           let context = PersistenceController.shared.context
           let request: NSFetchRequest<CDMovieEntity> = CDMovieEntity.fetchRequest()
           request.predicate = NSPredicate(format: "movieID == %lld AND userUID == %@", movieId, userId)
           return try? context.fetch(request).first
       }

       // MARK: - Debug
       func printAllUserMovies() {
           let context = PersistenceController.shared.context
           let fetchRequest: NSFetchRequest<CDMovieEntity> = CDMovieEntity.fetchRequest()

           do {
               let movies = try context.fetch(fetchRequest)
               for movie in movies {
                   print("\(movie.title ?? "") | Rating: \(movie.userRating) | Watched: \(movie.isWatched) | Liked: \(movie.isLiked) | Rated: \(movie.isRated) | UID: \(movie.userUID ?? "")")
               }
           } catch {
               print("Veriler alınamadı: \(error)")
           }
       }
    
    
    // MARK: - Get rated movies for a user
    func getRatedMovies(for userId: String) -> [CDMovieEntity]{
        let context = PersistenceController.shared.context
        let fetchRequest: NSFetchRequest<CDMovieEntity> = CDMovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userUID == %@ AND isRated == YES AND isLiked == YES AND userRating > 3", userId)
        fetchRequest.returnsObjectsAsFaults = false


        do {
            let results = try context.fetch(fetchRequest)
            print("RECOMMENDATIONMANAGER RATED MOVIES: \(results)")
            return results
        } catch {
            print("CoreData fetch hatası: \(error)")
            return []
        }
    }
}
