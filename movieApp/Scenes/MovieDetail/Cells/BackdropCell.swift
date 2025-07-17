//
//  BackdropCell.swift
//  movieApp
//
//  Created by özge kurnaz on 5.07.2025.
//

import UIKit
import SwiftUI


class BackdropCell: UITableViewCell {

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var posterImageView: UIImageView!
    
    
    // rating
    private let ratingView = CircularProgressView()
    
    
    func applyFadeMask(to imageView: UIImageView) {
        let gradient = CAGradientLayer()
        gradient.frame = imageView.bounds
        
        gradient.colors = [
            UIColor.black.cgColor,
            UIColor.black.cgColor,
            UIColor.clear.cgColor        // Alt: şeffaf
        ]
        gradient.locations = [0.0, 0.7
                              , 1.0]
        
        imageView.layer.mask = gradient
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyFadeMask(to: backgroundImageView)

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = false
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(ratingView)
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: backgroundImageView.widthAnchor, multiplier: 9.0/16.0),  // aspect ratio
            
            ratingView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -35),
            ratingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ratingView.widthAnchor.constraint(equalToConstant: 70),
            ratingView.heightAnchor.constraint(equalToConstant: 70),

            posterImageView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -80),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 3.0/2.0), // 2:3 oran
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1),
        
     ])
        applyPosterShadowAndBorder()
        contentView.backgroundColor = .clear
    }

    func setVotePercentage(_ percentage: Int){
        ratingView.percentage = percentage
    }
    
    private func applyPosterShadowAndBorder() {
        posterImageView.layer.cornerRadius = 4
        posterImageView.layer.masksToBounds = true

        posterImageView.layer.shouldRasterize = true
        posterImageView.layer.rasterizationScale = UIScreen.main.scale

        posterImageView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        posterImageView.layer.borderWidth = 0
    }
}
