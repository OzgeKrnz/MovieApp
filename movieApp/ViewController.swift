//
//  ViewController.swift
//  movieApp
//
//  Created by özge kurnaz on 6.05.2025.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("view yüklendi")
        
        Task{
            let movie1Struct = try await MovieService.shared.fetchMovie(title: "My Little Pony: A New Generation")
            let movie2Struct = try await MovieService.shared.fetchMovie(title: "John Wick")
            
            let film_descriptions = [movie1Struct.overview, movie2Struct.overview]
            
            
            do{
                // uzay vektöründe cümleler, baglamlar ve acıklamalar yer almalı.
            
                let vectorMovie1 = try await EmbeddingManager.shared.getEmbedding(for:film_descriptions[0])
                let vetorMovie2 = try await EmbeddingManager.shared.getEmbedding(for: film_descriptions[1])
                
                let similarityMatrix = CosineSimilarity().cosineSimilarity(a: vectorMovie1, b: vetorMovie2)
                print("Benzerlik oranı: \(similarityMatrix)")
                
               // let cosineSimilarity = CosineSimilarity().cosineSimilarity(a: vector, b: vector2)
                //print(" Cosine Similarity:\(cosineSimilarity)")
                
            }catch{
                print("Hata: \(error)")
            }
            
            
            
       
        }
    }


}
