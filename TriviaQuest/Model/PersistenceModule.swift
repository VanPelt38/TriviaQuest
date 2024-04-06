//
//  PersistenceModule.swift
//  TriviaQuest
//
//  Created by Jake Gordon on 06/04/2024.
//

import Foundation
import CoreData

protocol PersistenceModule {
    var managedObjectContext: NSManagedObjectContext { get }
}
