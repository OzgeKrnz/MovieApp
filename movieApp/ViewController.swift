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
            do{
                let vector = try await EmbeddingManager.shared.getEmbedding(for: "Inception is a sci-fi thriller about dreams.")
                print("embedding vectör boyutu: \(vector.count)")
            }catch{
                print("Hata: \(error)")
            }
            
            
            
            do{
                let movie = try await MovieService.shared.fetchMovie(title: "Babam ve Oğlum")
                print("Film Adı: \(movie.title)")
                print("Açıklaması: \(movie.overview)")
                print("poster url: \(movie.poster_path ?? "YOK")")
            }catch{
                print("Film hata: \(error)")
            }
        }
    }


}

