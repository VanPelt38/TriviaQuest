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
    @Published var questions: [Question] = []

    func load15Questions(networkManager: NetworkManagerModule) async {
        Task.init {
            self.getLoadedQuestions()
            if questions.isEmpty {
                let questionResponse = try await networkManager.get15Questions()
                self.persistQuestions(questionData: questionResponse)
                self.getLoadedQuestions()
            }
        }
    }
    
    func persistQuestions(questionData: Data?) {
        
        if let data = questionData {
            do {
                let result = try JSONDecoder().decode(TriviaResultsModel.self, from: data)
                
                var questionID = 1
                
                for question in result.results {
                    
                    let newQuestion = Question(context: context)
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
                            incorrectAnswer.correct = false
                            incorrectAnswer.number = Int16(incorrectAnswerNo)
                            incorrectAnswerNo += 1
                            incorrectAnswer.text = answer
                        }
                    } else {
                        
                        let rightAnswer = Answer(context: context)
                        rightAnswer.answer2Question = newQuestion
                        rightAnswer.correct = question.correct_answer == "True" ? true : false
                        rightAnswer.number = 1
                        let wrongAnswer = Answer(context: context)
                        wrongAnswer.answer2Question = newQuestion
                        wrongAnswer.correct = !rightAnswer.correct
                        wrongAnswer.number = 2
                    }
                }
                saveData(coreDataService: PersistenceController.shared)
            } catch {
                print("failure decoding json: \(error)")
            }
            
        }
    }
    
    func saveData(coreDataService: PersistenceModule) {
        
        do {
            try coreDataService.managedObjectContext.save()
        } catch {
            print("error saving questions")
        }
    }
    
    func getLoadedQuestions() {
            
            questions = []
            let request: NSFetchRequest<Question> = Question.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "number", ascending: true)
            request.sortDescriptors = [sortDescriptor]
            do {
                questions = try context.fetch(request)
                print("questions loaded: \(questions.count)")
            } catch {
                print("error loading issues from CD: \(error)")
            }
    }

}
