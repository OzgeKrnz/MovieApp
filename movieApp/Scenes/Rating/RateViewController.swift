//
//  RateViewController.swift
//  movieApp
//
//  Created by özge kurnaz on 13.07.2025.
//

import UIKit
import Cosmos

protocol RateViewControllerDelegate: AnyObject{
    func rateViewController(_ controller: RateViewController, didRate rating: Double)
}

class RateViewController: UIViewController {
    
    @IBOutlet weak var cosmosView: CosmosView!
    
    var delegate: RateViewControllerDelegate?
    var initialRating: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cosmosView.settings.fillMode = .half
        cosmosView.settings.starSize = 40
        cosmosView.settings.starMargin = 8
        cosmosView.settings.minTouchRating = 0
        cosmosView.backgroundColor = .clear
        cosmosView.rating = initialRating
        cosmosView.settings.emptyBorderColor = .green
        cosmosView.settings.filledColor = .green
        
        view.backgroundColor = UIColor(red: 39/255, green: 63/255, blue: 79/255, alpha: 1)
        

        
        cosmosView.didTouchCosmos = { [weak self] rating in
            guard let self = self else {return}
            self.delegate?.rateViewController(self, didRate: rating)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.dismiss(animated: true)
            }
        }
    }
    

}
 
