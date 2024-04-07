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
        let dataModelName = "TriviaQuest"
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
    
//    func saveContext () {
//        let context = self.managedObjectContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//
//        }
//    }

}

