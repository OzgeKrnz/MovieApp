//
//  MovieDetailViewModel.swift
//  movieApp
//
//  Created by özge kurnaz on 4.07.2025.
//

import Foundation
import FirebaseAuth

struct MovieDetailViewModel{
    private let movie: Movie
    
    init(movie: Movie){
        self.movie = movie
    }
    
    var title: String {movie.title}
    var overview: String {movie.overview}
    var posterURL: URL? {movie.posterUrl}
    var backdropURL: URL? {movie.backdropURL}
    var voteAverage: Double? {movie.voteAverage}
    
    
    func updateStatus(to newStatus: String){
        UserMovieManager.shared.saveUserMovie(movie: movie, status: newStatus)
        
    }
  
    func updateRating(to newRating: Double) {
        print("Rating güncelleniyor: \(newRating)")
        UserMovieManager.shared.saveUserMovie(movie: movie, rating: newRating)
    }
    
    // MARK: - Core Data'dan Durum Bilgileri (booleans)

    func getIsWatched(for uid: String) -> Bool {
        return UserMovieManager.shared.getIsWatched(for: Int64(movie.id), userId: uid)
    }

    func getIsLiked(for uid: String) -> Bool {
        return UserMovieManager.shared.getIsLiked(for: Int64(movie.id), userId: uid)
    }

    func getIsRated(for uid: String) -> Bool {
        return UserMovieManager.shared.getIsRated(for: Int64(movie.id), userId: uid)
    }

    func getRating(for uid: String) -> Float? {
        return UserMovieManager.shared.getRating(for: Int64(movie.id), userId: uid)
    }
}
