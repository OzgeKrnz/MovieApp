//
//  RecommendationManager.swift
//  movieApp
//
//  Created by özge kurnaz on 18.07.2025.
//

import FirebaseAuth
import Foundation

class RecommendationManager {

    static let shared = RecommendationManager()

    private init() {}

    // kullanıcının oyladıgı film embeddingleri
    func getRecommendations(for userId: String, top count: Int = 5) async throws -> [Movie] {
        
        
        if let baseVector = try await getUserEmbedding(userId: userId) {
            var results: [(id: Int, similarity: Double)] = []
            let cosine = CosineSimilarity()
            for (movieIdStr, vector) in EmbeddingCacheManager.shared.cache {
                guard let movieId = Int(movieIdStr) else { continue }
                let sim = cosine.cosineSimilarity(a: baseVector, b: vector)
                results.append((id: movieId, similarity: sim))
            }
            let eps = 1e-9
            let sorted = results.sorted {
                let d = $0.similarity - $1.similarity
                return abs(d) > eps ? d > 0 : $0.id < $1.id
            }
            let watchedIDs = UserMovieManager.shared.getWatchedMovieIDs(for: userId)
            let pickedIDs = sorted.lazy.map(\.id).filter { !watchedIDs.contains($0) }.prefix(count)
            let movies: [Movie] = try await withThrowingTaskGroup(of: (Int, Movie?).self) { group in
                for id in pickedIDs { group.addTask { (id, try? await MovieService.shared.fetchMovieDetails(movieId: id)) } }
                var dict: [Int: Movie] = [:]
                for try await (id, m) in group { if let m { dict[id] = m } }
                return pickedIDs.compactMap { dict[$0] }
            }
            return Array(movies.prefix(count))
        }

        // cold start
        let topRated = try await MovieService.shared.fetchTopRatedMovies()
        return Array(topRated.prefix(count))
    }


    // ort embedding
    private func getUserEmbedding(userId: String) async throws -> [Double]? {
        let ratedMovies = UserMovieManager.shared.getRatedMovies(for: userId)
        guard !ratedMovies.isEmpty else { return nil }
        
        
        var accum: [Double]? = nil
        var totalW: Double = 0

        for m in ratedMovies {
            let idStr = String(Int(m.movieID))
            guard let vec = EmbeddingCacheManager.shared.getEmbedding(for: idStr) else {
                continue // cache’te yoksa atla
            }

            let norm = sqrt(vec.reduce(0.0) { $0 + $1*$1 })
            let unit = norm > 0 ? vec.map { $0 / norm } : vec

            let rating = Double(m.userRating)
            var w: Double
            if rating >= 3.5 { w = 1.0 }
            else if rating >= 3.0 { w = 0.5 }
            else { w = 0.1 }
            if m.isLiked { w += 0.2 }

            if accum == nil { accum = Array(repeating: 0.0, count: unit.count) }
            for i in 0..<unit.count { accum![i] += unit[i] * w }
            totalW += w
        }

        guard var avg = accum, totalW > 0 else { return nil }
        for i in 0..<avg.count { avg[i] /= totalW }
        let norm = sqrt(avg.reduce(0.0) { $0 + $1*$1 })
        return norm > 0 ? avg.map { $0 / norm } : avg
    }
}
