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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cosmosView.settings.fillMode = .half
        cosmosView.rating = 0
        
        cosmosView.didTouchCosmos = { [weak self] rating in
            guard let self = self else {return}
            self.delegate?.rateViewController(self, didRate: rating)
            self.dismiss(animated: true)
        }
    }
    

}
 
