//
//  TestPersistence.swift
//  TriviaQuest
//
//  Created by Jake Gordon on 07/04/2024.
//

import Foundation
import CoreData

class TestPersistence: PersistenceModule {
    
    static let shared = TestPersistence()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let dataModelName = "TriviaQuestTest"
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: TestPersistence.self)])!
        
        let container = NSPersistentContainer(name: dataModelName, managedObjectModel: managedObjectModel)
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { storeDescription, error in
            
            if let error = error as NSError? {
                fatalError("Failed to load store")
            }
        }
        return container.viewContext
    }()
}

