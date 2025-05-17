//
//  MovieService.swift
//  movieApp
//
//  Created by özge kurnaz on 6.05.2025.
//

import Foundation


// getApiKey -> Secrets tan key oluyacak
// fetchMovie(title:) verilen filmi arayıp sonucu döndürecek

class MovieService{
    
    static let shared = MovieService()


    private var apiKey:String{
        get{
            
            guard let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist")else{
                fatalError("Dosya yok")
            }
            
            
            // key-value saklanır.
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "TMDB_API_KEY") as? String else{
                fatalError("API KEy bulunamadı")
            }
            
            return value
            
        }
    }
    
    
    // aranılan filme erişme
    func fetchMovie(title:String) async throws->Movie{
        //özel karakterler icin
        let encodedTitle = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? title
        
        let urlString =  "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(encodedTitle)"
        
        guard let url = URL(string: urlString) else{
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        
        
        let (data,response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else{
            throw URLError(.badServerResponse)
        }
        
        //JSON DECODE
        let decoded = try JSONDecoder().decode(MovieSearchResponse.self, from: data)
        
        guard let firstMovie = decoded.results.first else{
          fatalError("decode edilmedi")
        }
        return firstMovie
        
    }
    
    //Popüler filmlere erişme
    func fetchPopulerMovies() async throws->[Movie]{
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&page=1"
        
        guard let url = URL(string: urlString) else{
            throw URLError(.badURL)
        }
        
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        //JSON DECODE
        let decoded = try JSONDecoder().decode(MovieSearchResponse.self, from: data)
        
        return decoded.results
        
        
    }
    
    
}
