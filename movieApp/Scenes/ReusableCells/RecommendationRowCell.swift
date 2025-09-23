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
        if !movies.isEmpty{
            self.recommendedMovies = movies
            self.collectionView.reloadData()
        }

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

        if let url = movie.posterUrl {
            ImageLoader.load(from: url, into: cell.posterImageView)
        } else {
            cell.posterImageView.image = nil
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets {

        if section == 0 {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        } else {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let h = collectionView.bounds.height * 0.9 
        let w = h * 0.66
        return CGSize(width: w, height: h)
        
    }

    
}
