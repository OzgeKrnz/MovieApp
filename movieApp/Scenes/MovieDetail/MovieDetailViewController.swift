//
//  MovieDetailViewController.swift
//  movieApp
//
//  Created by özge kurnaz on 21.05.2025.
//

import UIKit
import FirebaseAuth

class MovieDetailViewController: BaseViewController, UITableViewDelegate,
                                 UITableViewDataSource , RateViewControllerDelegate, StatusSelectorCellDelegate{
    
    func statusSelectorCell(_ cell: StatusSelectorCell, didSelectStatus status: UserMovieManager.MovieStatus) {
        switch status {
        case .rated:
            showRateViewController()
        default:
            viewModel.updateStatus(to: status.rawValue)
            tableView.reloadData()
        }
    }
    

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
    
    
    func rateViewController(_ controller: RateViewController, didRate rating: Double) {
        viewModel.updateRating(to: rating)
        tableView.reloadData()
    }
    
    func showRateViewController(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let rateVC = sb.instantiateViewController(withIdentifier: "RateViewController") as! RateViewController
        rateVC.delegate = self
        
        if let sheet = rateVC.sheetPresentationController{
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        rateVC.modalPresentationStyle = .pageSheet
        present(rateVC, animated: true)
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
            cell.delegate = self
            let uid = Auth.auth().currentUser?.uid ?? ""
            let isWatched = viewModel.getIsWatched(for: uid)
            let isLiked = viewModel.getIsLiked(for: uid)
            let isRated = viewModel.getIsRated(for: uid)
            
            cell.configure(isWatched: isWatched, isLiked: isLiked, isRated: isRated)

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
