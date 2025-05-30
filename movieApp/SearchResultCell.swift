//
//  SearchResultCell.swift
//  movieApp
//
//  Created by özge kurnaz on 29.05.2025.
//

import UIKit

class SearchResultCell: UITableViewCell{
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 4
        posterImageView.layer.borderWidth = 2
        posterImageView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        posterImageView.layer.masksToBounds = true
        
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        titleLabel.lineBreakMode = .byWordWrapping
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        
        
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            posterImageView.widthAnchor.constraint(equalToConstant: 75),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 3.0/2.0), // 2:3 oran
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 90),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            

            
            
        ])
        
        contentView.backgroundColor = .clear
        
        
        
    }
    
}
