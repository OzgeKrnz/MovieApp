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
    
    func getUserStatus(for uid: String) -> String?{
        return UserMovieManager.shared.getStatus(for: Int64(movie.id), userId: uid)
    }
    
    func updateStatus(to newStatus: String){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        UserMovieManager.setStatus(for: Int64(movie.id), userId: uid, status: newStatus)

    }
}
