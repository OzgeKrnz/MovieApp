//
//  RecommendedViewModel.swift
//  movieApp
//
//  Created by özge kurnaz on 20.07.2025.
//

import Foundation

@MainActor
class RecommendedViewModel {
    static let shared = RecommendedViewModel()
    private init() {}
    
    private var isLoaded = false
    private var loadTask: Task<Void, Never>?
    private(set) var recommendedMovies: [Movie] = []
    
    func loadIfNeeded(for userId: String, count: Int) async {
        guard !isLoaded else { return }
        isLoaded = true
        await refresh(for: userId, count: count)
    }
    
    func refresh(for userId: String, count: Int) async {
        let movies = (try? await RecommendationManager.shared
            .getRecommendations(for: userId, top: count)) ?? []
        self.recommendedMovies = movies
    }
    
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


