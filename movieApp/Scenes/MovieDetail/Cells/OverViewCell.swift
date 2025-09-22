//
//  OverViewCell.swift
//  movieApp
//
//  Created by özge kurnaz on 5.07.2025.
//

import UIKit

class OverViewCell: UITableViewCell{
    @IBOutlet var overviewTextLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    var infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 17)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        overviewTextLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textColor = .white
        overviewTextLabel.textColor = .white
        overviewTextLabel.numberOfLines = 0
        overviewTextLabel.lineBreakMode = .byWordWrapping
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewTextLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            // Title sağda üstte
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo:contentView.trailingAnchor, constant: -8),
            
            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            infoLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // Overview altında
            overviewTextLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 8),
            overviewTextLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            overviewTextLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            overviewTextLabel.bottomAnchor.constraint(equalTo:  contentView.bottomAnchor, constant: -16),
            
        ])
        
        contentView.backgroundColor = .clear

    }

}


