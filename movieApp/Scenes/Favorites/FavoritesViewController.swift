//
//  FavoritesViewController.swift
//  movieApp
//
//  Created by özge kurnaz on 25.07.2025.
//

import CoreData
import FirebaseAuth
import UIKit

class FavoritesViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    


    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var header: UILabel!

    let favoriteMoviesViewModel = FavoriteMoviesViewModel()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavoriteMovies()
        setupUI()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func loadFavoriteMovies() {
        favoriteMoviesViewModel.fetchFavoriteMovies()  
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    private func setupUI() {
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        header.translatesAutoresizingMaskIntoConstraints = false

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
        return favoriteMoviesViewModel.numberOfMovies()
    }
    
    
    func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "FavoriteMoviesCell", for: indexPath
            ) as? FavoritesViewCell
        else {
            return UICollectionViewCell()
        }

        let movie = favoriteMoviesViewModel.movie(at: indexPath.row)
        cell.configure(with: movie)
        return cell

    }

    // Get liked movies
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        let padding: CGFloat = 10
        let itemsPerRow: CGFloat = 3
        let totalPadding = padding * (itemsPerRow + 1)
        let itemWidth = (collectionView.frame.width - totalPadding) / itemsPerRow
        return CGSize(width: itemWidth, height: itemWidth * 1.5)
    }


}

class FavoritesViewCell: UICollectionViewCell {
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
            imageView.widthAnchor.constraint(equalToConstant: 100),
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
