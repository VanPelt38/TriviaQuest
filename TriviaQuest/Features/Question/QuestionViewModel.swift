//
//  QuestionViewModel.swift
//  TriviaQuest
//
//  Created by Jake Gordon on 06/04/2024.
//

import Foundation
import CoreData

class QuestionViewModel: ObservableObject {
    
    let context = PersistenceController.shared.managedObjectContext
    @Published var question: [Question] = []
    
    func getQuestion(_ number: Int) {
            
            let request: NSFetchRequest<Question> = Question.fetchRequest()
            let predicate = NSPredicate(format: "number == %d", number)
            request.predicate = predicate
            do {
                question = try context.fetch(request)
            } catch {
                print("error loading issues from CD: \(error)")
            }
    }

}
