//
//  ViewController.swift
//  movieApp
//
//  Created by özge kurnaz on 6.05.2025.
//

import UIKit

class SearchResultsVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet weak var tableView: UITableView!

    var searchedMovie: [Movie] = []
 

    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        
        
        tableView.rowHeight = 130
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .lightGray
        

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedMovie.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as? SearchResultCell else{return UITableViewCell()}
        
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        
        let searchedMovie = searchedMovie[indexPath.row]
        if let url = searchedMovie.posterUrl{
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
    
        cell.titleLabel.text = searchedMovie.title
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = searchedMovie[indexPath.row]
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = sb.instantiateViewController(identifier: "movieDetailID") as? MovieDetailViewController{
            detailVC.movieDetail = selectedMovie
            
            if let navController = self.navigationController{
                navController.pushViewController(detailVC, animated: true)
            }else{
                self.present(detailVC, animated: true, completion: nil)

            }
        }
    }
}


class ViewController: BaseViewController, UITextFieldDelegate, UICollectionViewDelegate,UICollectionViewDataSource, UISearchResultsUpdating, UISearchBarDelegate ,UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var searchController: UISearchController!
    
    
    var popularMovies : [Movie] = []
    let movieService = MovieService()
   
    var selectedMovieForDetail: Movie? // for prepare function
     
  
    
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
        
    
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let searchResultVC = sb.instantiateViewController(withIdentifier: "SearchResultsVC") as? SearchResultsVC
        
        searchController = UISearchController(searchResultsController: searchResultVC)
        navigationItem.searchController = searchController

        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.backgroundColor = UIColor.white
        searchController.searchBar.placeholder = "Search Movie"
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(didTapLogOutButton))

        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            
            collectionView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        ])
     
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
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchedText = searchController.searchBar.text else {
            return
        }
        Task{
            do{
                let searchedMovie = try await MovieService.shared.fetchMovie(title: searchedText)
                if let vc = searchController.searchResultsController as? SearchResultsVC {
                    vc.searchedMovie = searchedMovie
                    
                    DispatchQueue.main.async {
                        vc.tableView.reloadData()
                    }
                }
            
            }catch{
                print("searh error")
            }
        }
        
        print(searchedText)
      
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  popularMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell else{
            return UICollectionViewCell()
        }
        let movie =  popularMovies[indexPath.row]
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
    
    
    
    //MARK: selectors
    @objc func didTapLogOutButton(){
        AuthService.shared.signOut{[weak self] error in
            guard let self = self else {return}
            if let error = error {
                AlertManager.showLogoutErrorAlert(on: self, with: error)
                return
            }
            
            if let sceneDelegate = self.view.window?.windowScene?.delegate as?
                SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
    }
}
