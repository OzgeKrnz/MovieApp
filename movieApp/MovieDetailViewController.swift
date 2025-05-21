//
//  MovieDetailViewController.swift
//  movieApp
//
//  Created by özge kurnaz on 21.05.2025.
//

import UIKit

class MovieDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var tableView: UITableView!

    var movieDetail:Movie!
   

    
    override func viewDidLoad(){
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        
        tableView.rowHeight = UITableView.automaticDimension
        
        
        print(movieDetail.title)

        
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PosterCell") as! PosterCell
            
    
                  
            
            let movieDetails = movieDetail
            if let url = movieDetails?.backdropURL{
                URLSession.shared.dataTask(with: url){data, _,_ in
                    if let data = data{
                        DispatchQueue.main.async{
                            cell.backgroundImageView.image = UIImage(data: data)
                            
                            print("image frame:", cell.backgroundImageView.frame)
                        }
                    }
                }.resume()
                //print("backdrop url: \(movieDetails?.backdropURL)")
            }

            cell.backgroundColor = .clear

            return cell
            
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OverviewCell") as! OverviewCell
            cell.backgroundColor = .clear

            return cell
            
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RatingCell") as! RatingCell
            cell.backgroundColor = .clear

            return cell
            
                    
                
            
        
        default:
            return UITableViewCell()
            
        }

        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    
    
    
    

    
    
}


class PosterCell: UITableViewCell{
    @IBOutlet var backgroundImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFill
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: backgroundImageView.widthAnchor, multiplier: 9.0/16.0) // aspect ratio
        ])
        
        contentView.backgroundColor = .clear
    }
    
    
}

class OverviewCell: UITableViewCell{
    @IBOutlet var overviewTextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        overviewTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            overviewTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            overviewTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            overviewTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            overviewTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        contentView.backgroundColor = .clear
      
    }

}


class RatingCell: UITableViewCell{
    @IBOutlet var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            ratingLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            ratingLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
}
