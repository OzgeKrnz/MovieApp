//
//  Movie.swift
//  movieApp
//
//  Created by özge kurnaz on 6.05.2025.
//

import Foundation


struct Movie: Codable{
    
    var title: String
    var overview: String
    var release_date:String
    var genre_ids:[Int]
    var poster_path: String?
    var backdrop_path: String?
    
    var posterUrl: URL? {
        guard let path = poster_path else {
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/w500/\(path)")
    }
    
    var backdropURL: URL?{
        guard let path = backdrop_path else{
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/w500/\(path)")
    }
    
    
}


struct MovieSearchResponse:Codable{
    let results: [Movie]
}
