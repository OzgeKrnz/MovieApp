//
//  StatusSelectorCellTableViewCell.swift
//  movieApp
//
//  Created by özge kurnaz on 5.07.2025.
//

import UIKit

protocol StatusSelectorCellDelegate: AnyObject {
    func statusSelectorCell(_ cell: StatusSelectorCell, didSelectStatus status: UserMovieManager.MovieStatus)
}

class StatusSelectorCell: UITableViewCell {

    @IBOutlet var stackView: UIStackView!
    weak var delegate: StatusSelectorCellDelegate?

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
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor) 
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        buttons.forEach {
            $0.setImage(nil, for: .normal)
            $0.tintColor = .systemGray
        }
    }

    private func setupButtons() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        buttons.removeAll()

        for (index, status) in statuses.enumerated() {
            let button = UIButton(type: .system)
            let image = UIImage(systemName: status.iconName)
            button.setImage(image, for: .normal)
            button.tintColor = .systemGray
            button.backgroundColor = UIColor(red: 39/255, green: 63/255, blue: 79/255, alpha: 1)
            button.layer.cornerRadius = 10
            button.imageView?.contentMode = .scaleAspectFit

            button.tag = index
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 45),
                button.heightAnchor.constraint(equalToConstant: 45)
            ])

            stackView.addArrangedSubview(button)
            buttons.append(button)
        }

        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 16
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        let selectedStatus = statuses[sender.tag]
        delegate?.statusSelectorCell(self, didSelectStatus: selectedStatus)
    }

    func configure(isWatched: Bool, isLiked: Bool, isRated: Bool) {
        for (index, button) in buttons.enumerated() {
            switch statuses[index] {
            case .watched:
                let imageName = isWatched ? "eye.fill" : "eye"
                button.setImage(UIImage(systemName: imageName), for: .normal)
                button.tintColor = isWatched ? .green : .systemGray

            case .liked:
                let imageName = isLiked ? "heart.fill" : "heart"
                button.setImage(UIImage(systemName: imageName), for: .normal)
                button.tintColor = isLiked ? .green : .systemGray

            case .rated:
                let imageName = isRated ? "star.fill" : "star"
                button.setImage(UIImage(systemName: imageName), for: .normal)
                button.tintColor = isRated ? .green : .systemGray
            }
        }
    }
}
