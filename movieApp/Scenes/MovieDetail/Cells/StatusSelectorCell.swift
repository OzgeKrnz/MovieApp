//
//  StatusSelectorCellTableViewCell.swift
//  movieApp
//
//  Created by özge kurnaz on 5.07.2025.
//

import UIKit

class StatusSelectorCell: UITableViewCell {
    
    @IBOutlet var stackView: UIStackView!
    
    private let statuses = UserMovieManager.MovieStatus.allCases
    
    private let plannedButton = UIButton()
    private let watchedButton = UIButton()
    private let likedButton = UIButton()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        configureButton(plannedButton, systemImageName: "calendar.badge.clock")
        configureButton(watchedButton, systemImageName: "eye.fill")
        configureButton(likedButton, systemImageName: "heart.fill")
        
        stackView.addArrangedSubview(plannedButton)
        stackView.addArrangedSubview(watchedButton)
        stackView.addArrangedSubview(likedButton)
        
        stackView.alignment = .center
        stackView.distribution = .fillEqually

        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        stackView.backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
   

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    private func configureButton(_ button: UIButton, systemImageName: String) {
        let image = UIImage(systemName: systemImageName)
        button.setImage(image, for: .normal)
        button.tintColor = .systemGray
        button.backgroundColor = UIColor(red: 39/255, green: 63/255, blue: 79/255, alpha: 1)

        button.layer.cornerRadius = 0

        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 45),
            button.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
}
