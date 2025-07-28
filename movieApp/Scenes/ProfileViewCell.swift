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
        
        iconView.tintColor = .gray
        titleLabel.textColor = .white
    }

    public func configure(with item: ProfileMenuItem) {
        titleLabel.text = item.title
        iconView.image = UIImage(systemName: item.iconName)
    }


}
