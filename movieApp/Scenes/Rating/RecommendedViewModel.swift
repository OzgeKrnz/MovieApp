//
//  RecommendedViewModel.swift
//  movieApp
//
//  Created by özge kurnaz on 20.07.2025.
//

import Foundation

class RecommendedViewModel {
    
    var recommendedMovies: [Movie] = []
    
    func fetchRecommendedMovies(for userId: String) async{
        do {
            
            self.recommendedMovies = try await RecommendationManager.shared.getRecommendations(for: userId)
            print("ÖNERİ ALINIYOR")
        } catch {
            print("önri alınamadı")
        }
    }
    
    func movie(at index: Int)-> Movie{
        return recommendedMovies[index]
    }
    func numberOfRecommendations()->Int{
        return recommendedMovies.count
    }
}
