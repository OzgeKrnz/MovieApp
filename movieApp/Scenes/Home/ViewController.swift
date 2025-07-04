//
//  ViewController.swift
//  movieApp
//
//  Created by özge kurnaz on 6.05.2025.
//

import UIKit

class ViewController: BaseViewController, UITextFieldDelegate, UICollectionViewDelegate,UICollectionViewDataSource, UISearchResultsUpdating, UISearchBarDelegate ,UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let mainViewModel = MainViewModel()

    
    var searchController: UISearchController!

    let movieService = MovieService()
   
    var selectedMovieForDetail: Movie? // for prepare function
     
    
    //SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare cagrıldı")

        if segue.identifier == "movieDetail",
           let indexPath = sender as? IndexPath,
           let destinationVC = segue.destination as? MovieDetailViewController{
            
            let selectedMovie = mainViewModel.movie(at: indexPath.row)
            let viewModel = MovieDetailViewModel(movie: selectedMovie)
            destinationVC.viewModel = viewModel
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
        
        
        //FETCH USER
        AuthService.shared.fetchUser {  [weak self] user, error in
            guard let self = self else {return}
            if let error = error {
                AlertManager.showFetchingUserError(on: self, with: error)
            }
          
        }

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
            await mainViewModel.fetchPopularMoies()
            self.collectionView.reloadData()
            
            //FOR SEARCH
            //let movie1 = try await MovieService.shared.fetchMovie(title: "Inception")
            //let overview1 = movie1.overview
            
            //let movie2 = try await MovieService.shared.fetchMovie(title: "Elemental")
            //let overview2 = movie2.overview

       
                
                //let vector1 = try await EmbeddingManager.shared.getEmbedding(for: overview1)
                //let vector2 = try await EmbeddingManager.shared.getEmbedding(for: overview2)
                //let cosineSimilarity = CosineSimilarity().cosineSimilarity(a: vector1, b: vector2)
                //print("BEnzerlik oranı: \(cosineSimilarity)")
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
                    vc.searchedMovie.setMovies(searchedMovie)
                    DispatchQueue.main.async {
                        vc.tableView.reloadData()
                    }
                }
            
            }catch{
                print("searh error")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  mainViewModel.numberOfMovies()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell else{
            return UICollectionViewCell()
        }
        let movie =  mainViewModel.movie(at: indexPath.row)
        if let url = movie.posterUrl{
            ImageLoader.load(from: url, into: cell.posterImageView)
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
