//
//  AllQuestionsViewModel.swift
//  TriviaQuest
//
//  Created by Jake Gordon on 06/04/2024.
//

import Foundation
import CoreData

class AllQuestionsViewModel: ObservableObject {
    
    let context = PersistenceController.shared.managedObjectContext

    func load15Questions(networkManager: NetworkManagerModule) {
        Task.init {
            let questionResponse = try await networkManager.get15Questions()
            self.persistQuestions(questionData: questionResponse)
        }
    }
    func persistQuestions(questionData: Data?) {
        
        if let data = questionData {
            do {
                let result = try JSONDecoder().decode(TriviaResultsModel.self, from: data)
                
                var questionID = 1
                
                for question in result.results {
                    
                    var newQuestion = Question(context: context)
                    newQuestion.number = Int16(questionID)
                    questionID += 1
                    newQuestion.category = question.category
                    newQuestion.difficulty = question.difficulty
                    newQuestion.text = question.question
                    newQuestion.type = question.type
                    if question.type == "multiple" {
                    
                    let correctAnswer = Answer(context: context)
                        correctAnswer.answer2Question = newQuestion
                        correctAnswer.correct = true
                        correctAnswer.number = 1
                        correctAnswer.text = question.correct_answer
                        
                        var incorrectAnswerNo = 2
                        
                        for answer in question.incorrect_answers {
                            let incorrectAnswer = Answer(context: context)
                            incorrectAnswer.answer2Question = newQuestion
                            incorrectAnswer.correct = true
                            incorrectAnswer.number = Int16(incorrectAnswerNo)
                            incorrectAnswerNo += 1
                            incorrectAnswer.text = answer
                        }
                    }
                }
                saveData()
            } catch {
                print("failure decoding json: \(error)")
            }
            
        }
    }
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("error saving questions")
        }
    }

}
