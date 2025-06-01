//
//  MovieDetailViewController.swift
//  movieApp
//
//  Created by özge kurnaz on 21.05.2025.
//

import UIKit

class MovieDetailViewController: BaseViewController, UITableViewDelegate,
    UITableViewDataSource
{

    @IBOutlet var tableView: UITableView!

    var movieDetail: Movie!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension

        // print(movieDetail.title)

    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {

        switch indexPath.section {
        case 0:
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "BackdropCell")
                as! BackdropCell

            let movieDetails = movieDetail

            //backdrop image load
            if let backdropImageUrl = movieDetails?.backdropURL {
                URLSession.shared.dataTask(with: backdropImageUrl) {
                    data, _, _ in
                    if let data = data {
                        DispatchQueue.main.async {
                            cell.backgroundImageView.image = UIImage(data: data)

                            print(
                                "image frame:", cell.backgroundImageView.frame)
                        }
                    }
                }.resume()
                //print("backdrop url: \(movieDetails?.backdropURL)")
            }

            // poster image load
            if let posterUrl = movieDetails?.posterUrl {
                URLSession.shared.dataTask(with: posterUrl) { data, _, _ in
                    if let data = data {
                        DispatchQueue.main.async {
                            cell.posterImageView.image = UIImage(data: data)
                            print("image frame:", cell.posterImageView.frame)
                        }
                    }
                }.resume()
                //print("backdrop url: \(movieDetails?.backdropURL)")
            }
            cell.backgroundColor = .clear

            return cell

            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OverViewCell") as! OverViewCell
            cell.backgroundColor = .clear
            
            cell.titleLable.text = movieDetail.title
            cell.overviewTextLabel.text = movieDetail.overview
            return cell
    

        case 2:
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "RatingCell")
                as! RatingCell
            cell.backgroundColor = .clear

            return cell

        default:
            return UITableViewCell()

        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return 1
    }
    
    
    


}

class BackdropCell: UITableViewCell {

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var posterImageView: UIImageView!
    
    
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
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        

        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: backgroundImageView.widthAnchor, multiplier: 9.0/16.0),  // aspect ratio

            posterImageView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -80),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 3.0/2.0), // 2:3 oran
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1),
            

            
            
            
     ])
        applyPosterShadowAndBorder()
        contentView.backgroundColor = .clear
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

class RatingCell: UITableViewCell {
    @IBOutlet var ratingLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.text = "⭐️ 6.7"

        NSLayoutConstraint.activate([
            ratingLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            ratingLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -8),
            ratingLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -8),
        ])

        contentView.backgroundColor = .clear
    }

}

