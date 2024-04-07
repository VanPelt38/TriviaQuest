//
//  Persistence.swift
//  TriviaQuest
//
//  Created by Jake Gordon on 06/04/2024.
//

import CoreData

struct PersistenceController: PersistenceModule {

    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TriviaQuest")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        managedObjectContext.automaticallyMergesChangesFromParent = true
    }
    var managedObjectContext: NSManagedObjectContext {
        container.viewContext
    }
}
