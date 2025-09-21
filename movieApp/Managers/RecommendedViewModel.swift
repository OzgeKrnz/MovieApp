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
    
    private var cache: [String: [Movie]] = [:]
    private var loading: [String: Bool] = [:]
    
    private var lastUserId: String?
    private var isLoaded = false
    private var loadTask: Task<Void, Never>?
    
    private(set) var recommendedMovies: [Movie] = []
    
    func loadIfNeeded(for userId: String, count: Int) async {
        if lastUserId != userId {
            isLoaded = false
            recommendedMovies = cache[userId] ?? []
            lastUserId = userId
        }
        guard !isLoaded else { return }
        isLoaded = true
        await refresh(for: userId, count: count)
    }
    
    func refresh(for userId: String, count: Int) async {
        if loading[userId] == true { return }
        loading[userId] = true
        defer { loading[userId] = false }
        
        let movies = (try? await RecommendationManager.shared
            .getRecommendations(for: userId, top: count)) ?? []
        
        cache[userId] = movies
        if lastUserId == userId {
            recommendedMovies = movies
        }
    }
    
    func resetCurrentUser() {
        isLoaded = false
        recommendedMovies.removeAll()
        lastUserId = nil
    }
    
    // uid bazlı erişim
    func movies(for userId: String) -> [Movie] {
        return cache[userId] ?? []
    }
    
    func movie(for userId: String, at index: Int) -> Movie? {
        return cache[userId]?[index]
    }
    
    func numberOfRecommendations(for userId: String) -> Int {
        return cache[userId]?.count ?? 0
    }
}
