//
//  EmbeddingHelper.swift
//  movieApp
//
//  Created by özge kurnaz on 18.07.2025.
//

import Foundation

class EmbeddingHelper {
    
    struct EmbeddedMovie {
        let movie: Movie
        let vector: [Double]
    }
    
    static func generateEmbeddedMovies(from movies: [Movie]) -> [EmbeddedMovie] {
        let cache = EmbeddingCacheManager.shared.cache
        var result: [EmbeddedMovie] = []
        
        for movie in movies {
            let movieId = String(movie.id)
            if let vector = cache[movieId] {
                result.append(EmbeddedMovie(movie: movie, vector: vector))
            }
        }
        
        print("Toplam \(result.count) embedded movie oluşturuldu.")
        return result
    }
}
