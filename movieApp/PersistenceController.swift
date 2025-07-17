//
//  PsersistenceConroller.swift
//  movieApp
//
//  Created by özge kurnaz on 5.07.2025.
//

import Foundation
import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    var context: NSManagedObjectContext {
        return container.viewContext
    }

    private init() {
        container = NSPersistentContainer(name: "CDMovie")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData yüklenemedi: \(error)")
            }
        }
    }
}
