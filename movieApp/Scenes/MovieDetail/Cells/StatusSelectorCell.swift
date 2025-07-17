//
//  StatusSelectorCellTableViewCell.swift
//  movieApp
//
//  Created by özge kurnaz on 5.07.2025.
//

import UIKit

protocol StatusSelectorCellDelegate: AnyObject{
    func statusSelectorCell(_ cell: StatusSelectorCell, didSelectStatus status: UserMovieManager.MovieStatus)
}

class StatusSelectorCell: UITableViewCell {
 
    @IBOutlet var stackView: UIStackView!
    var delegate: StatusSelectorCellDelegate?
    
    private let statuses = UserMovieManager.MovieStatus.allCases
    
    private var buttons: [UIButton] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButtons()
        stackView.backgroundColor = .clear
        contentView.backgroundColor = UIColor(red: 39/255, green: 63/255, blue: 79/255, alpha: 1)
     
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    private func setupButtons(){
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview()}
        buttons = []
        
        for(index, status) in statuses.enumerated(){
            let button = UIButton()
            let image = UIImage(systemName: status.iconName)
            button.setImage(image, for: .normal)
            button.backgroundColor = UIColor(red: 39/255, green: 63/255, blue: 79/255, alpha: 1)

            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 45),
                button.heightAnchor.constraint(equalToConstant: 45)
            ])
            button.tag = index
                       button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

                       stackView.addArrangedSubview(button)
                       buttons.append(button)
        }
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 16
    }
    
    
    @objc func buttonTapped(_ sender: UIButton){
        let selectedStatus = statuses[sender.tag]
        delegate?.statusSelectorCell(self, didSelectStatus: selectedStatus)
        updateButtonColors(selectedStatus:selectedStatus.rawValue)
    }
    
    func configure(isWatched: Bool, isLiked: Bool, isRated: Bool) {
        for(index, button) in buttons.enumerated(){
            let status = statuses[index]
            switch status {
            case .watched:
                button.tintColor = isWatched ? .orange : .systemGray
            case .liked:
                button.tintColor = isLiked ? .orange : .systemGray
            
            case .rated:
                button.tintColor = isRated ? .orange : .systemGray
            }
        }
    }
    
    private func updateButtonColors(selectedStatus: String?) {
        for (index, button) in buttons.enumerated() {
            let status = statuses[index].rawValue
            button.tintColor = (status == selectedStatus) ? .systemOrange : .systemGray
        }
    }
    

  
}
