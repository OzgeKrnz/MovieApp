//
//  OverViewCell.swift
//  movieApp
//
//  Created by özge kurnaz on 5.07.2025.
//

import UIKit

class OverViewCell: UITableViewCell{
    @IBOutlet var overviewTextLabel: UILabel!
    @IBOutlet var titleLable: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLable.font = UIFont.boldSystemFont(ofSize: 25)
        overviewTextLabel.font = UIFont.systemFont(ofSize: 17)
        titleLable.textColor = .white
        overviewTextLabel.textColor = .white
        overviewTextLabel.numberOfLines = 0
        overviewTextLabel.lineBreakMode = .byWordWrapping
        
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        overviewTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Title sağda üstte
            titleLable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            titleLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),

            titleLable.trailingAnchor.constraint(equalTo:contentView.trailingAnchor, constant: -8),
            // Overview altında
            overviewTextLabel.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 8),
            overviewTextLabel.leadingAnchor.constraint(equalTo: titleLable.leadingAnchor),
            overviewTextLabel.trailingAnchor.constraint(equalTo: titleLable.trailingAnchor),
            overviewTextLabel.bottomAnchor.constraint(equalTo:  contentView.bottomAnchor, constant: -16),
            
        ])
        
        contentView.backgroundColor = .clear

    }

}


