//
//  ViewController.swift
//  movieApp
//
//  Created by özge kurnaz on 6.05.2025.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{
    
    //text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        Task {
            await searchMovie()
        }
        return true
    }
    
    
   

    @IBOutlet weak var searchBar: UITextField!
    
    @IBOutlet weak var textLabel: UILabel!
    
    
    var movies : [Movie] = []
    let movieService = MovieService()
    
    func searchMovie() async {
        let searchedText = searchBar.text ?? ""
        do {
            let movie = try await MovieService.shared.fetchMovie(title: searchedText)
            textLabel.text = movie.overview
            collapseLabelWithBlur(textLabel)
        } catch {
            print("Hata: \(error)")
        }
    }
    
    @objc func searchMovieButtonTapped() {
        Task {
            await self.searchMovie()
        }
    }
    
    @objc func expandLabel() {
        textLabel.numberOfLines = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }

        // Blur'ları temizle
        textLabel.subviews.forEach {
            if $0 is UIVisualEffectView {
                $0.removeFromSuperview()
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 39/255, green: 63/255, blue: 79/255, alpha: 1)
        
        
        searchBar.delegate = self
        searchBar.placeholder = "What do you want to watch?"
        searchBar.backgroundColor = UIColor(red: 79/255, green: 112/255, blue: 148/255, alpha: 1) // #4F7087
        searchBar.layer.cornerRadius = 10
        searchBar.clipsToBounds = true
        searchBar.attributedPlaceholder = NSAttributedString(
            string: "What do you want to watch?",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1.0, alpha: 0.6)]
        )
   
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(expandLabel))
        textLabel.isUserInteractionEnabled = true
        textLabel.addGestureRecognizer(tap)
        print("view yüklendi")
   
        
        
        Task{
            
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
    
    
    func collapseLabelWithBlur(_ label: UILabel) {
        // 1. Satır sınırı
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.clipsToBounds = true
        
        // 2. Önceki fade'leri temizle (eğer varsa)
        label.layer.sublayers?
            .filter { $0.name == "fadeMask" }
            .forEach { $0.removeFromSuperlayer() }
        
        // 3. Gradient mask oluştur
        let fadeMask = CAGradientLayer()
        fadeMask.name = "fadeMask"
        fadeMask.frame = label.bounds
        fadeMask.colors = [
            UIColor.white.cgColor,
            UIColor.white.cgColor,
            UIColor.clear.cgColor
        ]
        fadeMask.locations = [0.0, 0.85, 1.0] // en altta yumuşak geçiş
        label.layer.mask = fadeMask
        
    }

}
