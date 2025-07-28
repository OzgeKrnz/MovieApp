//
//  FavoritesViewController.swift
//  movieApp
//
//  Created by özge kurnaz on 25.07.2025.
//

import UIKit
import CoreData
import FirebaseAuth

class FavoritesViewController:  BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavoriteMovies()

    }
    
    private func loadFavoriteMovies(){
        let favoriteMovies = fetchFavoriteMovies()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    
    private func setupUI(){
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    
    
    // Get liked movies
    private func fetchFavoriteMovies()-> [CDMovieEntity]{
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Kullanıcı giriş yapmamış")
            return []
        }
        
        let context = PersistenceController.shared.context
        let fetchRequest: NSFetchRequest<CDMovieEntity> = CDMovieEntity.fetchRequest()
        
       
        
        fetchRequest.predicate = NSPredicate(format: "userUID == %@ AND isLiked == YES", uid)
        fetchRequest.returnsObjectsAsFaults = false


        do {
            let results = try context.fetch(fetchRequest)
            print("favorite movies: \(results)")
            
            
            return results
        } catch {
            print("CoreData fetch hatası: \(error)")
            return []
        }
    }
    
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

            let padding: CGFloat = 10
            let itemsPerRow: CGFloat = 3
            let totalPadding = padding * (itemsPerRow + 1)
            let itemWidth =
                (collectionView.frame.width - totalPadding) / itemsPerRow
            return CGSize(width: itemWidth, height: itemWidth * 1.5)
        }
  
        
}



class FavoritesViewCell: UICollectionViewCell{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    
    
    
    
    
    
    
}
