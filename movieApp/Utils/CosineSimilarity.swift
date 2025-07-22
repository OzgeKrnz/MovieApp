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
        
        // düzeltme: text-embedding-3-large modeline gecildigi icin vektörleri normalize ediyorz
        let normA = normalize(a)
        let normB = normalize(b)
        
        
        return dot(a: normA, b:normB)
     
    }
    
    // normalize fonksiyonu
    private func normalize(_ vector: [Double]) -> [Double] {
        let mag = magnitude(a: vector)
        guard mag != 0 else {return vector}
        
        return vector.map { $0 / mag }
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
                
    static func textFunc() {
        let cos = CosineSimilarity()

        let a = [1.0, 2.0, 3.0]
        let b = [1.0, 2.0, 3.0]
        let c = [-1.0, -2.0, -3.0]
        let d = [0.0, 0.0, 0.0]

        print(cos.cosineSimilarity(a: a, b: b)) // → 1.0 (aynı yön)
        print(cos.cosineSimilarity(a: a, b: c)) // → -1.0 (zıt yön)
        print(cos.cosineSimilarity(a: a, b: d))
    }
    

                
}
