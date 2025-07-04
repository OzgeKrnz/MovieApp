//
//  ImageLoader.swift
//  movieApp
//
//  Created by özge kurnaz on 4.07.2025.
//

import UIKit

class ImageLoader{
    
    static func load(from url: URL, into imageView: UIImageView){
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}
