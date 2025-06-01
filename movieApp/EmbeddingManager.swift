//
//  EmbeddingManager.swift
//  movieApp
//
//  Created by özge kurnaz on 6.05.2025.
//

import Foundation

class EmbeddingManager{
    
    static let shared = EmbeddingManager()
    
    private let endpoint = "https://api.openai.com/v1/embeddings"
    private let embeddingModel = "text-embedding-ada-002"
    
    
    
    
    struct EmbeddingResponse:Decodable{
        let data: [EmbeddingData]
    }
    
    struct EmbeddingData:Decodable{
        let embedding: [Double]
    }
    
    
    // api key yükleme
    private var apiKey:String{
        get{
            guard let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist")else{
                fatalError("Dosya bulunamadı")
            }
            
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "OPENAI_API_KEY") as? String else{
                fatalError("API KEY bulunamadı.")
            }
            print("API Key yüklendi.... \(value.prefix(10))")
            return value
        }
    }
    
    // verilen metn, embedding model ile vektöre dönüştürme
    func getEmbedding(for text:String) async throws ->[Double]{
        
        // get url
        guard let url = URL(string: endpoint) else{
            throw URLError(.badURL)
        }
        
        
        //request
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
     

        
        let body: [String:Any] = [
            "input":text,
            "model":embeddingModel
        ]
        print(body)
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else{
            throw URLError(.badServerResponse)
        }
        //print("Status Code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")

     
        
        
        //decode json
        let decoded = try JSONDecoder().decode(EmbeddingResponse.self, from: data)
        
        return decoded.data.first?.embedding ?? []
    }
}
