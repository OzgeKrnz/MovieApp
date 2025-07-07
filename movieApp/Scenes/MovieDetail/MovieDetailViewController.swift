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
    @IBOutlet var buttonStackView: UIStackView!

    var viewModel: MovieDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension

        // print(movieDetail.title)

    }
    
    private func setStatusButtons(){
        
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {

        switch indexPath.section {
        case 0:
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "BackdropCell")
                as! BackdropCell


            //backdrop image load
            if let backdropImageUrl = viewModel.backdropURL {
                ImageLoader.load(from: backdropImageUrl, into: cell.backgroundImageView)
            }

            // poster image load
            if let posterUrl = viewModel.posterURL {
                ImageLoader.load(from: posterUrl, into: cell.posterImageView)
            }
            
            //rating
            let vote = Int(ceil(viewModel.voteAverage * 10))
            print("Movie vote: ", viewModel.voteAverage)
            print("Yüzdelik:", Int(ceil(viewModel.voteAverage * 10)))

            cell.setVotePercentage(vote)
            print("VOTE:", vote)
            
            
            cell.backgroundColor = .clear

            return cell

            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OverViewCell") as! OverViewCell
            cell.backgroundColor = .clear
            
            cell.titleLable.text = viewModel.title
            cell.overviewTextLabel.text = viewModel.overview
            
            return cell

        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatusSelectorCell") as! StatusSelectorCell
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
