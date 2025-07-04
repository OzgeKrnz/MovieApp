//
//  SearchResultsVC.swift
//  movieApp
//
//  Created by özge kurnaz on 5.07.2025.
//

import UIKit

class SearchResultsVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var searchedMovie = SearchResultsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        
        
        tableView.rowHeight = 130
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .lightGray
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedMovie.numberOfMovies()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as? SearchResultCell else{return UITableViewCell()}
        
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        let searchedMovie = searchedMovie.movie(at: indexPath.row)
        if let url = searchedMovie.posterUrl{
            ImageLoader.load(from: url, into: cell.posterImageView)
        }else{
            cell.posterImageView.image = nil
        }
    
        cell.titleLabel.text = searchedMovie.title
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = searchedMovie.movie(at: indexPath.row)
        let viewModel = MovieDetailViewModel(movie: selectedMovie)
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = sb.instantiateViewController(identifier: "movieDetailID") as? MovieDetailViewController{
            detailVC.viewModel = viewModel
            
            if let navController = self.navigationController{
                navController.pushViewController(detailVC, animated: true)
            }else{
                self.present(detailVC, animated: true, completion: nil)

            }
        }
    }
}

