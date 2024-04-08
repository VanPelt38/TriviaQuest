//
//  WelcomeViewModel.swift
//  TriviaQuest
//
//  Created by Jake Gordon on 08/04/2024.
//

import Foundation
import CoreData

class WelcomeViewModel: ObservableObject {
    
    func deleteQuestions(coreDataService: PersistenceModule) {
        
        let request: NSFetchRequest<Question> = Question.fetchRequest()
        do {
            let questions = try coreDataService.managedObjectContext.fetch(request)
            for q in questions {
                coreDataService.managedObjectContext.delete(q as NSManagedObject)
            }
            try coreDataService.managedObjectContext.save()
        } catch {
            fatalError("Error deleting question objects")
        }
    }
}
