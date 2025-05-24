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
    func fetchMovie(title:String) async throws->[Movie]{
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
        
      
        let sortedResults = decoded.results.sorted{movie1, movie2 in
            let searched = title.lowercased()
            let s1 = similarity(title: movie1.title.lowercased(), query:searched)
            let s2 = similarity(title: movie1.title.lowercased(), query:searched)
            
            return s1>s2

        }
        return sortedResults
    }
    
    func similarity(title: String, query:String)->Int{
        if title == query{
            return 3
            
        }else if title.hasPrefix(query){
            return 2
        }else if title.contains(query){
            return 1
        }else{
            return 0
        }
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
