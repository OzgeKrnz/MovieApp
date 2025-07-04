//
//  PsersistenceConroller.swift
//  movieApp
//
//  Created by özge kurnaz on 5.07.2025.
//

import Foundation

class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    var context: NSManagedObjectContext {
        return container.viewContext
    }

    private init() {
        container = NSPersistentContainer(name: "movieApp")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData yüklenemedi: \(error)")
            }
        }
    }
}
