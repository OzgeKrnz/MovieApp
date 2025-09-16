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
    func getRecommendations( for userId: String, top count: Int = 5
    ) async throws -> [Movie] {
        
        if let baseVector = try await getUserEmbedding(userId: userId) {
            // movieEmbedding.json'dan similarity hesabı
            guard let baseVector = try await getUserEmbedding(userId: userId) else {
                let topRated = try await MovieService.shared.fetchTopRatedMovies()
                return Array(topRated.prefix(count))
            }
            
            var results: [(id: Int, similarity: Double)] = []
            let cosine = CosineSimilarity()
            for (movieIdStr, vector) in EmbeddingCacheManager.shared.cache {
                guard let movieId = Int(movieIdStr) else { continue }
                let sim = cosine.cosineSimilarity(a: baseVector, b: vector)
                results.append((id: movieId, similarity: sim))
            }
            
            // En benzer top X film id’lerini al
            let eps = 1e-9
            let sorted = results
                .sorted {
                    let d = $0.similarity - $1.similarity
                    if abs(d) > eps { return d > 0 }
                    return $0.id < $1.id
                }
 
            let watchedIDs = UserMovieManager.shared.getWatchedMovieIDs(for: userId) // Set<Int>
            var pickedIDs: [Int] = []
            pickedIDs.reserveCapacity(count)
            for item in sorted where !watchedIDs.contains(item.id) {
                pickedIDs.append(item.id)
                if pickedIDs.count == count { break }
            }
            
            let movies: [Movie] = try await withThrowingTaskGroup(of: (Int, Movie?).self) { group in
                for id in pickedIDs {
                    group.addTask {
                        let m = try? await MovieService.shared.fetchMovieDetails(movieId: id)
                        return (id, m)
                    }
                }
                var dict: [Int: Movie] = [:]
                for try await (id, m) in group { if let m { dict[id] = m } }
                return pickedIDs.compactMap { dict[$0] }
            }
            return Array(movies.prefix(count))

        }
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
            let w = 0.5 + (rating/5.0) * 1.0 + (m.isLiked ? 0.5 : 0.0)

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
