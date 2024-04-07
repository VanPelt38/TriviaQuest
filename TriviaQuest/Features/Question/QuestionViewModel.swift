//
//  QuestionViewModel.swift
//  TriviaQuest
//
//  Created by Jake Gordon on 06/04/2024.
//

import Foundation
import CoreData

class QuestionViewModel: ObservableObject {
    
    @Published var question: [Question] = []
    @Published var answers: [Answer] = []
    
    func getQuestion(_ number: Int, coreDataService: PersistenceModule) {
        
        let request: NSFetchRequest<Question> = Question.fetchRequest()
        let predicate = NSPredicate(format: "number == %d", number)
        request.predicate = predicate
        do {
            question = try coreDataService.managedObjectContext.fetch(request)
        } catch {
            print("error loading issues from CD: \(error)")
        }
        for q in question {
            if let answers = q.question2Answer as? Set<Answer> {
                for a in answers {
                    self.answers.append(a)
                }
            }
        }
    }
    
    func saveData(coreDataService: PersistenceModule) {
        
        do {
            try coreDataService.managedObjectContext.save()
        } catch {
            print("error saving CD: \(error)")
        }
    }
}
