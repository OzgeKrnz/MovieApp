//
//  RecommendationMovieCell.swift
//  movieApp
//
//  Created by özge kurnaz on 22.07.2025.
//

import UIKit

class RecommendationMovieCell: UICollectionViewCell{
    
    @IBOutlet weak var posterImageView: UIImageView!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        posterImageView.layer.cornerRadius = 4

        contentView.backgroundColor = UIColor.systemBackground
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 5
        layer.masksToBounds = false
        
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImageView.image = nil
   
    }
}
