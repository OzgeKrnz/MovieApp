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

        print(movieDetail.title)

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
            // title and overview load
            let movieDetailsOverview = movieDetail
            if let url = movieDetailsOverview?.backdropURL {
                URLSession.shared.dataTask(with: url) { data, _, _ in

                    DispatchQueue.main.async {
                        cell.overviewTextLabel.text =
                            movieDetailsOverview?.overview

                    }
                }.resume()
                //print("backdrop url: \(movieDetails?.backdropURL)")
            }
            
            if let titleUrl = movieDetailsOverview?.backdropURL {
                URLSession.shared.dataTask(with: titleUrl) { data, _, _ in
                    DispatchQueue.main.async {
                        cell.titleLable.text =
                        movieDetailsOverview?.title

                    }
                }.resume()
            }
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
        return 2
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
 

    override func awakeFromNib() {
        super.awakeFromNib()

        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        
        
        contentView.addSubview(posterImageView)
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: backgroundImageView.widthAnchor, multiplier: 9.0/16.0),  // aspect ratio

            posterImageView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: 124),
            posterImageView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 16),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 3.0/2.0), // 2:3 oran
//            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
     ])
        contentView.backgroundColor = .clear
        applyPosterShadowAndBorder()
    }

    
    private func applyPosterShadowAndBorder() {
        posterImageView.layer.cornerRadius = 4
        posterImageView.layer.masksToBounds = false

        posterImageView.layer.shadowColor = UIColor.black.cgColor
        posterImageView.layer.shadowOpacity = 0.4
        posterImageView.layer.shouldRasterize = true
        posterImageView.layer.rasterizationScale = UIScreen.main.scale

        posterImageView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        posterImageView.layer.borderWidth = 1.0
    }


}

class OverViewCell: UITableViewCell{
    @IBOutlet var overviewTextLabel: UILabel!
    @IBOutlet var titleLable: UILabel!
    
    
    override func awakeFromNib() {
        
        titleLable.textColor = .white
        overviewTextLabel.textColor = .white
        overviewTextLabel.numberOfLines = 0
        overviewTextLabel.lineBreakMode = .byWordWrapping
        
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        overviewTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Title sağda üstte
            titleLable.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLable.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 90),

            titleLable.trailingAnchor.constraint(equalTo:contentView.trailingAnchor, constant: -16),
            // Overview altında
            overviewTextLabel.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 69),
            overviewTextLabel.leadingAnchor.constraint(equalTo: titleLable.leadingAnchor),
            overviewTextLabel.trailingAnchor.constraint(equalTo: titleLable.trailingAnchor),
            overviewTextLabel.bottomAnchor.constraint(equalTo:  contentView.bottomAnchor, constant: -16),
            
         
        ])

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

