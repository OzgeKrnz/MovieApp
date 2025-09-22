//
//  ConfigManager.swift
//  movieApp
//
//  Created by özge kurnaz on 22.09.2025.
//

import Foundation


enum ConfigManager {
    static func stringValue(for key: String) -> String {
        guard let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist") else {
            fatalError(" Secrets.plist bulunamadı.")
        }

        guard let plist = NSDictionary(contentsOfFile: filePath) else {
            fatalError(" Secrets.plist okunamadı.")
        }

        guard let value = plist.object(forKey: key) as? String else {
            fatalError("\(key) bulunamadı.")
        }

        print("\(key) yüklendi: \(value.prefix(10))...")
        return value
    }
}
