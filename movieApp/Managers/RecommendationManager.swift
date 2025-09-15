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
            var results: [(id: Int, similarity: Double)] = []
            
            for (movieIdStr, vector) in EmbeddingCacheManager.shared.cache {
                guard let movieId = Int(movieIdStr) else {continue}
                let similarity = CosineSimilarity().cosineSimilarity(a: baseVector, b: vector)
                results.append((id: movieId, similarity: similarity))
            }
            
            // En benzer top X film id’lerini al
            let topMovieIDs = results
                .sorted(by: { $0.similarity > $1.similarity })
                .prefix(count)
                .map { $0.id }
            
            // Bu ID'lere göre Movie objelerini async olarak API’den çek
            var recommendedMovies: [Movie] = []
            
            for id in topMovieIDs {
                if let movie = try? await MovieService.shared.fetchMovieDetails(movieId: id) {
                    recommendedMovies.append(movie)
                }
            }
            
            if !recommendedMovies.isEmpty {
                print("recommended dolu")
                return recommendedMovies
            }
        }
        let topRated = try await MovieService.shared.fetchTopRatedMovies()
        return Array(topRated.prefix(count))
    }

    // ort embedding
    private func getUserEmbedding(userId: String) async throws -> [Double]? {
        let ratedMovies = UserMovieManager.shared.getRatedMovies(for: userId)
        if ratedMovies.isEmpty { return nil }

        if ratedMovies.count == 1 {
            let movie = ratedMovies[0]
            let title = movie.title ?? ""
            let overview = movie.overview ?? ""
            let text = overview.isEmpty ? title : "Title: \(title)\nPlot: \(overview)"
            return try await EmbeddingManager.shared.getEmbedding(for: text)
            }

            // 1'den fazla film varsa ortalama embedding
            var embeddings: [[Double]] = []
            
            for movie in ratedMovies {
                let title = movie.title ?? ""
                let overview = movie.overview ?? ""
                
                let text = overview.isEmpty ? title : "Title: \(title)\nPlot: \(overview)"
                print("Embeddiing icin alınan film: \(title)")

                if let vector = try? await EmbeddingManager.shared.getEmbedding(for: text) {
                    embeddings.append(vector)
                }
            }

            guard !embeddings.isEmpty else { return nil }

            let vectorLength = embeddings[0].count
            var avgVector = Array(repeating: 0.0, count: vectorLength)

            for vector in embeddings {
                for i in 0..<vectorLength {
                    avgVector[i] += vector[i]
                }
            }

            for i in 0..<vectorLength {
                avgVector[i] /= Double(embeddings.count)
            }

            return avgVector

    }
}
