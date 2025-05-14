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
    
    
}


struct MovieSearchResponse:Codable{
    let results: [Movie]
}
