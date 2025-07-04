//
//  EmbeddingCacheManager.swift
//  movieApp
//
//  Created by özge kurnaz on 27.06.2025.
//

import Foundation

class EmbeddingCacheManager {

    static let shared = EmbeddingCacheManager()

    private init() {}

    private var cache: [String: [Double]] = [:]

    private var fileURL: URL {
        let manager = FileManager.default
        let urls = manager.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0].appendingPathComponent("movieEmbeddings.json")
    }

    // api key yükleme
    
    private var tmdbApiKey: String {
        guard
            let filePath = Bundle.main.path(
                forResource: "Secrets", ofType: "plist")
        else {
            fatalError("Secrets.plist bulunamadı.")
        }

        let plist = NSDictionary(contentsOfFile: filePath)
        guard let key = plist?.object(forKey: "TMDB_API_KEY") as? String
        else {
            fatalError("TMDB_API_KEY bulunamadı.")
        }

        print("TMDb API Key yüklendi: \(key.prefix(10))")
        return key
    }

    // JSON'dan cache yükle
    func loadCache() {
        do {
            let data = try Data(contentsOf: fileURL)
            cache = try JSONDecoder().decode(
                [String: [Double]].self, from: data)
            print("Embedding cache yüklendi: \(cache.count) adet film")
        } catch {
            print(
                "İlk defa çalışıyor olabilir, cache yok: \(error.localizedDescription)"
            )
            cache = [:]
        }
    }

    // Tek bir embedding getir
    func getEmbedding(for movieId: String) -> [Double]? {
        return cache[movieId]
    }

    // Embedding hesapla + cache'e ekle + dosyaya yaz
    func fetchAndStoreEmbedding(movieId: String, text: String) async {
        if cache[movieId] != nil {
            print("\(movieId) zaten cache'te")
            return
        }

        do {
            let embedding = try await EmbeddingManager.shared.getEmbedding(
                for: text)
            cache[movieId] = embedding

            let data = try JSONEncoder().encode(cache)
            try data.write(to: fileURL, options: .atomic)
            print("\(movieId) için embedding eklendi. Toplam: \(cache.count)")
        } catch {
            print("Hata oluştu: \(error.localizedDescription)")
        }
    }

    // top 5000 film cekme
    func populateTop5000() async {
        for page in 1...250 {
            let urlString =
                "https://api.themoviedb.org/3/movie/popular?api_key=\(tmdbApiKey)&page=\(page)"

            guard let url = URL(string: urlString) else {
                print("gecersiz url")
                continue
            }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                struct Response: Decodable {
                    let results: [Movie]
                }

                let decoded = try JSONDecoder().decode(
                    Response.self, from: data)

                for movie in decoded.results {
                    let text = movie.title + " " + movie.overview
                    await self.fetchAndStoreEmbedding(
                        movieId: String(movie.id), text: text)
                    try await Task.sleep(nanoseconds: 200_000_000)  // 0.2 saniye bekle (rate-limit için)
                }

                print("\(page). sayfa işlendi.")
                try await Task.sleep(nanoseconds: 500_000_000)  // her sayfa sonunda biraz daha bekle
            } catch {
                print("Hata (page \(page)): \(error.localizedDescription)")
            }
        }

        print(" Tüm popüler filmler işlendi!")
    }

}
