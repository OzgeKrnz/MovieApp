//
//  ViewController.swift
//  movieApp
//
//  Created by özge kurnaz on 6.05.2025.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    
    func searchMovie(){
        textField.resignFirstResponder()
        
        //network
    }
    
    
    //table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        let movie = movies[indexPath.row]
        
        if let imageView = cell.viewWithTag(1) as? UIImageView {
            if let url = movie.posterUrl {
                 loadImage(from: url, into: imageView)
             } else {
                 imageView.image = UIImage(systemName: "photo")
             }
         }
        
        return cell
    }
    
    func loadImage(from url: URL, into imageView: UIImageView) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }.resume()
    }
    
   
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    
    var movies : [Movie] = []
    let movieService = MovieService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        textField.delegate = self
        
        print("view yüklendi")
        
        
        
        
        
        
        
        
        
        
        Task{
            
            
            do{
                self.movies = try await MovieService.shared.fetchPopulerMovies()
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            }
            
            
            
            let movie1 = try await MovieService.shared.fetchMovie(title: "Inception")
            let overview1 = movie1.overview
            
            let movie2 = try await MovieService.shared.fetchMovie(title: "Elemental")
            let overview2 = movie2.overview

           
            
            do{
                
                let vector1 = try await EmbeddingManager.shared.getEmbedding(for: overview1)
                let vector2 = try await EmbeddingManager.shared.getEmbedding(for: overview2)

                let cosineSimilarity = CosineSimilarity().cosineSimilarity(a: vector1, b: vector2)
                
                print("BEnzerlik oranı: \(cosineSimilarity)")
                
            }catch{
                print("Hata: \(error)")
            }
            
            
            
            
        }
    }


}
