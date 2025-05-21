//
//  MovieCell.swift
//  movieApp
//
//  Created by özge kurnaz on 17.05.2025.
//

import UIKit

class MovieCell: UICollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    
   
    //let movies = try await MovieService.shared.fetchPopulerMovies()
    
    // HÜCREYİ TIKlANIR YAPMA
    
    
    
   
    
    //Hücre ilk yüklendiğinde çalışacak
    override func awakeFromNib() {
        super.awakeFromNib()
    
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        posterImageView.layer.cornerRadius = 4

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
        ])

        contentView.backgroundColor = UIColor.systemBackground
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 5
        layer.masksToBounds = false
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImageView.image = nil
   
    }
}

