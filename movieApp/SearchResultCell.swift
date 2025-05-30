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
        titleLabel.contentMode = .scaleAspectFill
        
        posterImageView.clipsToBounds = true
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        
        
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 3.0/2.0), // 2:3 oran
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            //titleLabel.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            

            
            
        ])
        
        contentView.backgroundColor = .clear
        
        
        
    }
    
}
