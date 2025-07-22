//
//  Movie.swift
//  movieApp
//
//  Created by özge kurnaz on 6.05.2025.
//

import Foundation


struct Movie: Codable, Identifiable{
    
    var title: String
    var overview: String
    var releaseDate:String?
    var genres: [Genre]?
    var id: Int
    var posterPath: String?
    var backdropPath: String?
    var voteAverage: Double?
    
    var posterUrl: URL? {
        guard let path = posterPath else {
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    var backdropURL: URL?{
        guard let path = backdropPath else{
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    enum CodingKeys: String, CodingKey {
        case title, overview, genres, id
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
    }
    

}

struct MovieSearchResponse:Codable{
    let results: [Movie]
}

struct Genre : Codable{
    let id: Int
    let name: String
}
