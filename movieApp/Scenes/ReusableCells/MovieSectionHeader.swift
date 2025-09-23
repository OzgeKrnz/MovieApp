//
//  MovieSectionHeader.swift
//  movieApp
//
//  Created by özge kurnaz on 23.07.2025.
//

import UIKit


class MovieSectionHeader: UICollectionReusableView{
    static let identifier = "SectionHedear"
    
    
    
    let titleLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var recommendationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 17)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addSubview(titleLabel)
        addSubview(recommendationLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant:10),
            recommendationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            recommendationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented ")
    }
    

}
