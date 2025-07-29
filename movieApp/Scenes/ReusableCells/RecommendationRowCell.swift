//
//  RecommendationRowCell.swift
//  movieApp
//
//  Created by özge kurnaz on 22.07.2025.
//

import Foundation
import UIKit

class RecommendationRowCell: UICollectionViewCell,UICollectionViewDelegateFlowLayout {
    

    @IBOutlet weak var collectionView: UICollectionView!
    var recommendedMovies: [Movie] = []
    


    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        
        
        collectionView.backgroundColor = .clear
 
    }
    func configure(with movies: [Movie]) {
        self.recommendedMovies = movies
        self.collectionView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("ROW CELL FRAME:", self.frame)
        print("COLLECTION VIEW FRAME:", collectionView.frame)
    }
}


extension RecommendationRowCell: UICollectionViewDelegate, UICollectionViewDataSource {
    


    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recommendedMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationMovieCell", for: indexPath) as? RecommendationMovieCell else {
            
            return UICollectionViewCell()
        }
        
        let movie = recommendedMovies[indexPath.row]
        
   
        print("RECOMMENDED MOVIE:", movie.title)
        print("POSTER URL:", movie.posterUrl ?? "nil")

        if let url = movie.posterUrl {
            ImageLoader.load(from: url, into: cell.posterImageView)
        } else {
            cell.posterImageView.image = nil
        }
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 120, height: collectionView.bounds.height)
    }

    
}
