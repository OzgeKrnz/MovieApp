//
//  MainViewModel.swift
//  movieApp
//
//  Created by özge kurnaz on 4.07.2025.
//

import Foundation

class MainViewModel {
    
    var movies: [Movie] = []
    
    func fetchPopularMoies() async {
        do {
            let result = try await MovieService.shared.fetchPopulerMovies()
            self.movies = result
        }catch{
            print("Hata: ", error)
        }
    }
    
    func movie(at index: Int)->Movie{
        return movies[index]
    }
    
    func numberOfMovies()->Int{
        return movies.count
    }
}
