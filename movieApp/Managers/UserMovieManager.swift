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
    
    
    let context = PersistenceController.shared.context
    
    func saveUserMovie(
        userUID: String,
        movieID:Int64,
        status:String,
        userRating:Float,
        overview:String,
        title: String,
        posterPath: String){
            
            guard let uid = Auth.auth().currentUser?.uid else {
                print("Kullanıcı giriş yapmamış")
                return
            }
            let userMovie = CDMovieEntity(context: context)
        
            userMovie.userUID = uid
            userMovie.movieID = movieID
            userMovie.status = status
            userMovie.userRating = userRating
            userMovie.overview = overview
            userMovie.title = title
            userMovie.posterPath = posterPath
            
            
            do {
                try context.save()
                print("Kullanıcı filmi kaydedildi ")
            }catch{
                print("core data hatası")
            }
            
        
    }
    
    func getStatus(for movieId: Int64, userId: String)->String? {
        let fetchRequest : NSFetchRequest<CDMovieEntity> = CDMovieEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "movieId ==  %lld AND userId == %@", "\(movieId)", userId)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first?.status
        }catch{
            print("status fetch failed", error)
            return nil
        }
    }
    
    static func setStatus(for movieId: Int64, userId: String, status: String){
        let fetchRequest : NSFetchRequest<CDMovieEntity> = CDMovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format:"movieId ==  %lld AND userId == %@", "\(movieId)", userId)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let existing = results.first {
                existing.status = status
            }else {
                let newEntry = CDMovieEntity(context: context)
                newEntry.movieID = movieId
                newEntry.userUID = userId
                newEntry.status = status
            }
            try context.save()
        } catch {
            print("status update failed.")
        }
        
    }
}
