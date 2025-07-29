//
//  ProfileViewCell.swift
//  movieApp
//
//  Created by özge kurnaz on 27.07.2025.
//

import UIKit

class ProfileViewCell: UITableViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        iconView.tintColor = .systemBlue
        titleLabel.textColor = .white
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // IconView constraints
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 18),
            iconView.heightAnchor.constraint(equalToConstant: 18),
            
            // TitleLabel constraints
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
   
    }

    func configure(title: String, iconName: String) {
        titleLabel.text = title
        iconView.image = UIImage(systemName: iconName)?
               .withConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .regular))
        
    }

}
