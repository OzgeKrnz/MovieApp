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
        
        contentView.insertSubview(bgCard, at: 0)

        
        NSLayoutConstraint.activate([
            
            bgCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bgCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            bgCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            bgCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // IconView constraints
            iconView.leadingAnchor.constraint(equalTo: bgCard.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: bgCard.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            // TitleLabel constraints
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: bgCard.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: bgCard.trailingAnchor, constant: -8)
        ])
        
       
   
    }
    
    private let bgCard: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.systemGray4.withAlphaComponent(0.5)
        v.layer.cornerRadius = 12
        v.layer.masksToBounds = false
        v.layer.shadowColor = UIColor.white.cgColor
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        v.layer.shadowRadius = 4

        return v

    }()

    func configure(title: String, iconName: String, iconColor: UIColor) {
        titleLabel.text = title
        iconView.image = UIImage(systemName: iconName)?
               .withConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .regular))
        
        iconView.tintColor = iconColor
        
    }

}
