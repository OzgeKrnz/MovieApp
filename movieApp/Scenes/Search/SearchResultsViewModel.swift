//
//  SearchResultsViewModel.swift
//  movieApp
//
//  Created by özge kurnaz on 5.07.2025.
//

import Foundation


class SearchResultsViewModel {
    
    var movies: [Movie] = []
    
    func numberOfMovies()->Int{
        movies.count
    }
    
    func movie(at index:Int)->Movie{
        movies[index]
    }
    
    func setMovies(_ newMovies: [Movie]){
        self.movies = newMovies
    }
}
