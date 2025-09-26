//
//  MovieDetailViewController.swift
//  movieApp
//
//  Created by özge kurnaz on 21.05.2025.
//

import UIKit
import FirebaseAuth
import CoreData

extension Notification.Name {
    static let didRateMovie = Notification.Name("didRateMovie")
}

class MovieDetailViewController: BaseViewController,
    UITableViewDelegate, UITableViewDataSource,
    RateViewControllerDelegate, StatusSelectorCellDelegate
{
    @IBOutlet var tableView: UITableView!
    @IBOutlet var buttonStackView: UIStackView!

    var viewModel: MovieDetailViewModel!

    private var cachedUserRating: Double?

    private var ctx: NSManagedObjectContext {
        PersistenceController.shared.context
    }

    override func viewDidLoad()  {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refetchUserRatingAndRefreshUI()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleDidRateMovie),
                                               name: .didRateMovie,
                                               object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .didRateMovie, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .didRateMovie, object: nil)
    }

    // MARK: - Status Selector
    func statusSelectorCell(_ cell: StatusSelectorCell, didSelectStatus status: UserMovieManager.MovieStatus) {
        switch status {
        case .rated:
            showRateViewController()
        default:
            viewModel.updateStatus(to: status.rawValue)
            tableView.reloadData()
        }
    }

    // MARK: - Rate Delegate
    func rateViewController(_ controller: RateViewController, didRate rating: Double) {
        viewModel.updateRating(to: rating)

        let uid = Auth.auth().currentUser?.uid ?? ""
        let movieId = Int64(viewModel.id)
        upsertRating(movieId: movieId, uid: uid, rating: rating)

        cachedUserRating = rating // UI’yı anında güncelle
        NotificationCenter.default.post(name: .didRateMovie, object: nil)
        tableView.reloadSections(IndexSet([2]), with: .automatic)
    }

    // MARK: - Present Rate Sheet
    func showRateViewController(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let rateVC = sb.instantiateViewController(withIdentifier: "RateViewController") as? RateViewController else {
             assertionFailure("Storyboard ID veya sınıf yanlış (RateViewController)")
             return
         }

        rateVC.delegate = self

        let uid = Auth.auth().currentUser?.uid ?? ""
        let movieId = Int64(viewModel.id)
        let existing = fetchSavedRating(movieId: movieId, uid: uid) // Double?
        cachedUserRating = existing
        rateVC.initialRating = existing ?? 0

        if let sheet = rateVC.sheetPresentationController{
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }

        rateVC.modalPresentationStyle = .pageSheet
        present(rateVC, animated: true)
    }

    // MARK: - Table
    func numberOfSections(in tableView: UITableView) -> Int { 3 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BackdropCell") as! BackdropCell
            if let backdropImageUrl = viewModel.backdropURL {
                ImageLoader.load(from: backdropImageUrl, into: cell.backgroundImageView)
            }
            if let posterUrl = viewModel.posterURL {
                ImageLoader.load(from: posterUrl, into: cell.posterImageView)
            }
            if let va = viewModel.voteAverage {
                let vote = Int(ceil(va * 10))
                cell.setVotePercentage(vote)
            }
            cell.backgroundColor = .clear
            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OverViewCell") as! OverViewCell
            cell.backgroundColor = .clear
            cell.titleLabel.text = viewModel.title
            cell.overviewTextLabel.text = viewModel.overview
            cell.infoLabel.text = viewModel.infoLine   // rating göstermiyoruz
            return cell

        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatusSelectorCell") as! StatusSelectorCell
            cell.delegate = self
            let uid = Auth.auth().currentUser?.uid ?? ""
            let isWatched = viewModel.getIsWatched(for: uid)
            let isLiked = viewModel.getIsLiked(for: uid)
            let isRated = (cachedUserRating ?? 0) > 0
            cell.configure(isWatched: isWatched, isLiked: isLiked, isRated: isRated)
            return cell

        default:
            return UITableViewCell()
        }
    }
}

// MARK: - Rating sync
private extension MovieDetailViewController {
    @objc func handleDidRateMovie() {
        refetchUserRatingAndRefreshUI()
    }

    func refetchUserRatingAndRefreshUI() {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let movieId = Int64(viewModel.id)
        cachedUserRating = fetchSavedRating(movieId: movieId, uid: uid)
        tableView.reloadSections(IndexSet([2]), with: .none)
    }

    func fetchSavedRating(movieId: Int64, uid: String) -> Double? {
        let req = NSFetchRequest<CDMovieEntity>(entityName: "CDMovieEntity")
        req.fetchLimit = 1
        req.predicate = NSPredicate(format: "movieID == %lld AND userUID == %@", movieId, uid)
        do {
            let results: [CDMovieEntity] = try ctx.fetch(req)
            guard let obj = results.first else { return nil }
            return Double(obj.userRating)
        } catch {
            print("fetchSavedRating error:", error)
            return nil
        }
    }

    func upsertRating(movieId: Int64, uid: String, rating: Double) {
        let req = NSFetchRequest<CDMovieEntity>(entityName: "CDMovieEntity")
        req.fetchLimit = 1
        req.predicate = NSPredicate(format: "movieID == %lld AND userUID == %@", movieId, uid)
        do {
            let results: [CDMovieEntity] = try ctx.fetch(req)
            let obj: CDMovieEntity = results.first ?? CDMovieEntity(context: ctx)
            obj.movieID = movieId
            obj.userUID = uid
            obj.userRating = Float(rating)
            try ctx.save()
        } catch {
            print("upsertRating error:", error)
        }
    }
}
