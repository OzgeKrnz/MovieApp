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
        setupUI()
        setupSearchController()
        setupNotifications()

        Task {
            await mainViewModel.fetchPopularMoies()
            DispatchQueue.main.async {
                self.collectionView.reloadSections(IndexSet(integer: 1))
            }
        }

        // embedding ve öneriler arka planda
        Task.detached {
            try? EmbeddingCacheManager.shared.loadEmbeddings()
            if let userId = Auth.auth().currentUser?.uid {
                await self.recommendedViewModel.fetchRecommendedMovies(
                    for: userId)
                DispatchQueue.main.async {
                    self.collectionView.reloadItems(at: [
                        IndexPath(item: 0, section: 0)
                    ])
                }
            }
        }

    }

    private func setupUI() {
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self

        if let layout = collectionView.collectionViewLayout
            as? UICollectionViewFlowLayout
        {
            layout.estimatedItemSize = .zero
        }

        // for titles
        collectionView.register(
            MovieSectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView
                .elementKindSectionHeader,
            withReuseIdentifier: MovieSectionHeader.identifier)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

        ])

    }

    private func setupSearchController() {

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
    }

    private func setupNotifications() {
        // Notification dinleme
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMovieRated),
            name: .didRateMovie,
            object: nil)
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

    func collectionView(
        _ collectionView: UICollectionView, numberOfItemsInSection section: Int
    ) -> Int {
        if section == 0 {
            return 1  // Yalnızca 1 hücre: yatay scroll içerir
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
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "RecommendationRowCell", for: indexPath
                ) as? RecommendationRowCell
            else {
                return UICollectionViewCell()
            }

            let recommendedMovies = recommendedViewModel.recommendedMovies
            cell.configure(with: recommendedMovies)

            return cell

        } else {
            // POPÜLER FİLMLER için normal hücre
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "MovieCell", for: indexPath
                ) as? MovieCell
            else {
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
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        let header =
            collectionView.dequeueReusableSupplementaryView(
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
    @objc private func handleMovieRated() {
        Task {
            if let userId = Auth.auth().currentUser?.uid {
                await recommendedViewModel.fetchRecommendedMovies(for: userId)
                collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
            }
        }
    }
}
