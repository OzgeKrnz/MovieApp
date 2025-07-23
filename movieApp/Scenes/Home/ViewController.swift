//
//  ViewController.swift
//  movieApp
//
//  Created by özge kurnaz on 6.05.2025.
//

import FirebaseAuth
import UIKit

class ViewController: BaseViewController, UITextFieldDelegate,
    UICollectionViewDelegate, UICollectionViewDataSource,
    UISearchResultsUpdating, UISearchBarDelegate,
    UICollectionViewDelegateFlowLayout
{

    @IBOutlet weak var collectionView: UICollectionView!

    let mainViewModel = MainViewModel()
    let recommendedViewModel = RecommendedViewModel()

    var searchController: UISearchController!

    let movieService = MovieService()

    var selectedMovieForDetail: Movie?  // for prepare function

    //MARK: - SEGUE for movie detail
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare cagrıldı")

        if segue.identifier == "movieDetail",
            let indexPath = sender as? IndexPath,
            let destinationVC = segue.destination as? MovieDetailViewController
        {

            let selectedMovie = mainViewModel.movie(at: indexPath.row)
            let viewModel = MovieDetailViewModel(movie: selectedMovie)
            destinationVC.viewModel = viewModel
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .clear
        
        UserMovieManager.shared.printAllUserMovies()
        
        //CosineSimilarity.textFunc()
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let searchResultVC =
        sb.instantiateViewController(withIdentifier: "SearchResultsVC")
        as? SearchResultsVC
        
        searchController = UISearchController(
            searchResultsController: searchResultVC)
        navigationItem.searchController = searchController
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.backgroundColor =
        UIColor.white
        searchController.searchBar.placeholder = "Search Movie"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = .zero
        }
        
        
        // Notification dinleme
         NotificationCenter.default.addObserver(self,
                                                selector: #selector(handleMovieRated),
                                                name: .didRateMovie,
                                                object: nil)

        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Log out", style: .plain, target: self,
            action: #selector(didTapLogOutButton))
        
        //testSimilarityBetweenMovies()
        
        
        // for titles
        collectionView.register(MovieSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MovieSectionHeader.identifier)
        
        NSLayoutConstraint.activate([
        
            collectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
        
        Task {
            do {
                try EmbeddingCacheManager.shared.loadEmbeddings()
                
                if let userId = Auth.auth().currentUser?.uid {
                    let recommended = try await RecommendationManager.shared.getRecommendations(for: userId, top: 5)
                    print(recommended)
                }
            } catch {
                print("❌ Embedding yüklenemedi veya öneri oluşturulamadı")
            }
            
            await mainViewModel.fetchPopularMoies()
            
            if let userId = Auth.auth().currentUser?.uid {
                await recommendedViewModel.fetchRecommendedMovies(for: userId)
                print("✅ Ana sayfa recommended count:", recommendedViewModel.numberOfRecommendations())
                
            }
            
            self.collectionView.reloadData()
        }
        
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchedText = searchController.searchBar.text else {
            return
        }
        Task {
            do {
                let searchedMovie = try await MovieService.shared.fetchMovie(
                    title: searchedText)
                if let vc = searchController.searchResultsController
                    as? SearchResultsVC
                {
                    vc.searchedMovie.setMovies(searchedMovie)
                    DispatchQueue.main.async {
                        vc.tableView.reloadData()
                    }
                }

            } catch {
                print("searh error")
            }
        }
    }

    // MARK: - Sections for popular & picked

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1 // Yalnızca 1 hücre: yatay scroll içerir
        } else {
            return mainViewModel.numberOfMovies()
        }
    }
    // MARK: - sections between popular movies & picked for you

    func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            // RecommendationRowCell içinde YATAY CollectionView var
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "RecommendationRowCell", for: indexPath
            ) as? RecommendationRowCell else {
                return UICollectionViewCell()
            }
            
            let recommendedMovies = recommendedViewModel.recommendedMovies
            cell.configure(with: recommendedMovies)

            
            return cell

        } else {
            // POPÜLER FİLMLER için normal hücre
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "MovieCell", for: indexPath
            ) as? MovieCell else {
                return UICollectionViewCell()
            }

            let movie = mainViewModel.movie(at: indexPath.row)
            if let url = movie.posterUrl {
                ImageLoader.load(from: url, into: cell.posterImageView)
            }
            return cell
        }
    }

    // MARK: - for movie detail page
    func collectionView(
        _ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath
    ) {
        performSegue(withIdentifier: "movieDetail", sender: indexPath)
    }

    // MARK: - grid / horizontal
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        // horizontal scroll görünüm RECOMMENDATİONS
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width, height: 180)
        } else {
            // Grid görünüm POPÜLER FİLMLER
            let padding: CGFloat = 10
            let itemsPerRow: CGFloat = 3
            let totalPadding = padding * (itemsPerRow + 1)
            let itemWidth =
                (collectionView.frame.width - totalPadding) / itemsPerRow
            return CGSize(width: itemWidth, height: itemWidth * 1.5)
        }
  
        
    }
    
    // MARK: - section for labels
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: MovieSectionHeader.identifier,
            for: indexPath
        ) as! MovieSectionHeader
        
        if indexPath.section == 0 {
            header.titleLabel.text = "Recommended for You"
        } else {
            header.titleLabel.text = "Weekly Popular"
        }
        
        return header
    }

    //MARK: - selectors
    @objc func didTapLogOutButton() {
        AuthService.shared.signOut { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showLogoutErrorAlert(on: self, with: error)
                return
            }

            if let sceneDelegate = self.view.window?.windowScene?.delegate
                as? SceneDelegate
            {
                sceneDelegate.checkAuthentication()
            }
        }
    }

    
    
    
    @objc private func handleMovieRated() {
        Task {
            if let userId = Auth.auth().currentUser?.uid {
                await recommendedViewModel.fetchRecommendedMovies(for: userId)
                collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
            }
        }
    }
    
    // similarity test
    func testSimilarityBetweenMovies() {
        /* Task {
         do {
         let movie1 = try await MovieService.shared.fetchMovie(title: "Moana 2")
         let movie2 = try await MovieService.shared.fetchMovie(title: "Frozen")
         let movie3 = try await MovieService.shared.fetchMovie(title: "Avengers: Endgame")
         let movie4 = try await MovieService.shared.fetchMovie(title: "Iron Man")

         guard
         let m1 = movie1.first,
         let m2 = movie2.first,
         let m3 = movie3.first,
         let m4 = movie4.first

         else {
         print("No movie")
         return
         }

         let base = m1.title + " " + m1.overview
         let baseVector = try await EmbeddingManager.shared.getEmbedding(for: base)

         let movieList = [m2,m3,m4]

         for movie in movieList {
         let text = movie.title + " " + movie.overview
         let vector = try await EmbeddingManager.shared.getEmbedding(for: text)
         let similarity = CosineSimilarity().cosineSimilarity(a: baseVector, b: vector)
         print("Moana vs \(movie.title): \(similarity)")
         }

         } catch {
         print("Hata oluştu: \(error.localizedDescription)")
         }

         }*/

    }

}
