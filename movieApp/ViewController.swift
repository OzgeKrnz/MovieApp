//
//  ViewController.swift
//  movieApp
//
//  Created by özge kurnaz on 6.05.2025.
//

import UIKit

class ViewController: BaseViewController, UITextFieldDelegate, UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate, UICollectionViewDelegateFlowLayout{
    
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

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var textLabel: UILabel!
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    var popularMovies : [Movie] = []
    var searchedMovie: [Movie] = []
    let movieService = MovieService()
    
    func searchMovie() async {
        let searchedText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        do {
            // arama yapılmıyosa popüler filmler listelensin
            if searchedText.isEmpty{
                
                popularMovies = try await MovieService.shared.fetchPopulerMovies()
            }else{
                searchedMovie = try await MovieService.shared.fetchMovie(title: searchedText)
                print(searchedMovie)

            }
            self.collectionView.reloadData()
            
        } catch {
            print("Hata: \(error.localizedDescription)")
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
        //textLabel.text = "Popular Movies"
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            textLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            
            collectionView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            

        ])

        searchBar.delegate = self
        searchBar.placeholder = "What do you want to watch?"
        searchBar.layer.cornerRadius = 10
        searchBar.clipsToBounds = true
     
   
        Task{
            //FOR POPULAR MOVIES
            popularMovies = try await MovieService.shared.fetchPopulerMovies()
            
            
            //FOR SEARCH
            
   
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
