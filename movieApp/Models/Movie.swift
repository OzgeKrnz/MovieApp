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
    var genreIds: [Int]?
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
        case genreIds = "genre_ids"
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


struct GenreResponse: Codable {
    let genres: [Genre]
}


final class GenreManager {
    static let shared = GenreManager()
    private init() {}
    
    private var genreMap: [Int: String] = [:]
    
    func fetchGenres(apiKey: String, completion: @escaping () -> Void) {
        let urlString = "https://api.themoviedb.org/3/genre/movie/list?api_key=\(apiKey)&language=tr-TR"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let response = try JSONDecoder().decode(GenreResponse.self, from: data)
                self.genreMap = Dictionary(uniqueKeysWithValues: response.genres.map { ($0.id, $0.name) })
                completion()
            } catch {
                print("Genre decode error:", error)
            }
        }.resume()
    }
    
    func name(for id: Int) -> String? {
        return genreMap[id]
    }
}
