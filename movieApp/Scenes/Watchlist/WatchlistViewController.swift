//
//  WatchlistViewController.swift
//  movieApp
//
//  Created by özge kurnaz on 11.08.2025.
//

//

//

import CoreData
import FirebaseAuth
import UIKit

class WatchlistViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var header: UILabel!

    let watchlistVM = WatchlistViewModel()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare cagrıldı")

        if segue.identifier == "movieDetail",
            let indexPath = sender as? IndexPath,
            let destinationVC = segue.destination as? MovieDetailViewController
        {

            let selectedMovie = watchlistVM.movie(at: indexPath.row)
            let viewModel = MovieDetailViewModel(movie: selectedMovie)
            destinationVC.viewModel = viewModel
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPlannedMovies()
        setupUI()
        
        
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.estimatedItemSize = .zero
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func loadPlannedMovies() {
        watchlistVM.fetchPlannedMovies()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    private func setupUI() {
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        header.translatesAutoresizingMaskIntoConstraints = false
        header.text = "İzleme Listesi"
        header.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            
            collectionView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 8),

            collectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return watchlistVM.numberOfMovies()
    }
    
    func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "WatchlistViewCell", for: indexPath
            ) as? WatchlistViewCell
        else {
            return UICollectionViewCell()
        }

        let movie = watchlistVM.movie(at: indexPath.row)
        cell.configure(with: movie)
        return cell

    }

    //MARK: - Get planned movies
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let spacing: CGFloat = 10
        let insets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)

        let total = insets.left + insets.right + spacing * (itemsPerRow - 1)
        let w = floor((collectionView.bounds.width - total) / itemsPerRow)
        return CGSize(width: w, height: w * 1.5)
    }
    
    // MARK: - for movie detail page
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = watchlistVM.movie(at: indexPath.row)
        let viewModel = MovieDetailViewModel(movie: selectedMovie)
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = sb.instantiateViewController(identifier: "movieDetailID") as? MovieDetailViewController{
            detailVC.viewModel = viewModel
            
            if let navController = self.navigationController{
                navController.pushViewController(detailVC, animated: true)
            }else{
                self.present(detailVC, animated: true, completion: nil)

            }
        }
    }}

class WatchlistViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        imageView.layer.cornerRadius = 4

        contentView.backgroundColor = UIColor.systemBackground
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 5
        layer.masksToBounds = false
        
        

        imageView.translatesAutoresizingMaskIntoConstraints = false
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        movieTitleLabel.textColor = .white
        movieTitleLabel.numberOfLines = 2
        movieTitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        movieTitleLabel.textAlignment = .center

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 3/2),

            movieTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            movieTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            movieTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            movieTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
        
        contentView.backgroundColor = .clear
    }
    
    func configure(with movie: Movie) {
        movieTitleLabel.text = movie.title
        if let url = movie.posterUrl{
            ImageLoader.load(from: url, into: imageView)

        } else {
            imageView.image = UIImage(systemName: "film")
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil

    }

}
