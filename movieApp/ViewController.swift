//
//  ViewController.swift
//  movieApp
//
//  Created by özge kurnaz on 6.05.2025.
//

import UIKit

class ViewController: BaseViewController, UITextFieldDelegate, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    //text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        Task {
            await searchMovie()
        }
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        popularMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell else{
            return UICollectionViewCell()
        }
  
    
        let movie = popularMovies[indexPath.row]
        if let url = movie.posterUrl{
            URLSession.shared.dataTask(with: url){data, _,_ in
                if let data = data{
                    DispatchQueue.main.async{
                        cell.posterImageView.image = UIImage(data: data)
                        //print("Cell size:", cell.frame.size)

                    }
                }
            }.resume()
        }else{
            cell.posterImageView.image = nil
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "movieDetail", sender: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let itemsPerRow: CGFloat = 3
        let totalPadding = padding * (itemsPerRow + 1)
        let itemWidth = (collectionView.frame.width - totalPadding) / itemsPerRow
        return CGSize(width: itemWidth, height: itemWidth * 1.5)
    }

    @IBOutlet weak var searchBar: UITextField!
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var popularMovies : [Movie] = []
    let movieService = MovieService()
    
    func searchMovie() async {
        let searchedText = searchBar.text ?? ""
        do {
            let movie = try await MovieService.shared.fetchMovie(title: searchedText)
        
            print(movie)
        } catch {
            print("Hata: \(error)")
        }
    }
    
    @objc func searchMovieButtonTapped() {
        Task {
            await self.searchMovie()
        }
    }
    
    //SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare cagrıldı")

        if segue.identifier == "movieDetail",
           let indexPath = sender as? IndexPath,
           let destinationVC = segue.destination as? MovieDetailViewController{
            let selectedMovie = popularMovies[indexPath.row]
            destinationVC.movieDetail = selectedMovie
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .clear
        textLabel.text = "Popular Movies"
        
 
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        tabBar.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: searchBar.topAnchor, constant: 60),
            textLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            
            collectionView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: -10),
    
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            tabBar.heightAnchor.constraint(equalToConstant: 60),
        ])

        tabBar.isTranslucent = false
        tabBar.backgroundColor =  UIColor(red: 79/255, green: 112/255, blue: 148/255, alpha: 1)
        searchBar.delegate = self
        searchBar.placeholder = "What do you want to watch?"
        searchBar.backgroundColor = UIColor(red: 79/255, green: 112/255, blue: 148/255, alpha: 1) // #4F7087
        searchBar.layer.cornerRadius = 10
        searchBar.clipsToBounds = true
        searchBar.attributedPlaceholder = NSAttributedString(
            string: "What do you want to watch?",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1.0, alpha: 0.6)]
        )
   
        Task{
            popularMovies = try await MovieService.shared.fetchPopulerMovies()
            
   
            //let movie1 = try await MovieService.shared.fetchMovie(title: "Inception")
            //let overview1 = movie1.overview
            
            //let movie2 = try await MovieService.shared.fetchMovie(title: "Elemental")
            //let overview2 = movie2.overview

           
            
            do{
                self.popularMovies = try await MovieService.shared.fetchPopulerMovies()
                DispatchQueue.main.async {
                           self.collectionView.reloadData()
                }
                
                //let vector1 = try await EmbeddingManager.shared.getEmbedding(for: overview1)
                //let vector2 = try await EmbeddingManager.shared.getEmbedding(for: overview2)
                //let cosineSimilarity = CosineSimilarity().cosineSimilarity(a: vector1, b: vector2)
                //print("BEnzerlik oranı: \(cosineSimilarity)")
                
            }catch{
                print("Hata Popüler filmler alınamadı: \(error)")
            }
            
            
            
            
        }
    }
    
    


}
