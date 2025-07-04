//
//  CosineSimilarity.swift
//  movieApp
//
//  Created by özge kurnaz on 13.05.2025.
//

import Foundation

class CosineSimilarity{
    
    
    func cosineSimilarity(a:[Double], b:[Double])->Double{
        
        // cosine similarity hesaplanması icin boyutlarının aynı olması gerekir.
        guard a.count == b.count else{
            return -1.0
        }
        
        let magA = magnitude(a: a)
        let magB = magnitude(a: b)
        
        if magA == 0 || magB == 0{
            // eger embedding vektörleri her zaman normalize yani uzunlugu 1 ise
            print("Vektörlerden biri veya her ikisi de sıfır vektörü")
            
            if magA == 0 && magB == 0 {
                return 1.0 // vektörler aynı yönde
            }
            
            return 0.0
            
        }
        
        return dot(a: a, b: b) / (magA * magB)
     
    }
    
    // iki vektörün karşılık gelen elemanlarının çarpımlarının toplamı
    private func dot(a:[Double], b:[Double])->Double{
        var x: Double = 0
        
        for i in 0...a.count - 1 {
            x += a[i] * b[i]
        }
        return x
    }
    
    // vektörün kendi büyüklüğünü ölcer
    private func magnitude(a:[Double])->Double{
        var x: Double = 0
        for elt in a{
            x += elt * elt
        }
        return sqrt(x)
    }
                
                
}
