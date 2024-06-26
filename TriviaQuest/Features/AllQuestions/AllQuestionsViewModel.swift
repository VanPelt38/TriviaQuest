//
//  AllQuestionsViewModel.swift
//  TriviaQuest
//
//  Created by Jake Gordon on 06/04/2024.
//

import Foundation
import CoreData

class AllQuestionsViewModel: ObservableObject {
    
    @Published var questions: [Question] = []
    @Published var networkErrorAlert = false
    @Published var isLoading = false
    
    func load15Questions(networkManager: NetworkManagerModule, coreDataService: PersistenceModule) async {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        getLoadedQuestions(coreDataService: coreDataService) { [self] in
            Task.init {
                if questions.isEmpty {
                    do {
                        let questionResponse = try await networkManager.get15Questions()
                        self.persistQuestions(questionData: questionResponse, coreDataService: coreDataService)
                        self.getLoadedQuestions(coreDataService: coreDataService) {
                            self.isLoading = false
                        }
                    } catch {
                        print("error loading questions: \(error)")
                        DispatchQueue.main.async {
                            self.isLoading = false
                            self.networkErrorAlert = true
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
            }
        }
    }
    
    func persistQuestions(questionData: Data?, coreDataService: PersistenceModule) {
        
        if let data = questionData {
            do {
                let result = try JSONDecoder().decode(TriviaResultsModel.self, from: data)
                
                var questionID = 1
                
                for question in result.results {
                    
                    let newQuestion = Question(context: coreDataService.managedObjectContext)
                    newQuestion.number = Int16(questionID)
                    questionID += 1
                    newQuestion.category = question.category
                    newQuestion.difficulty = question.difficulty
                    newQuestion.text = question.question
                    newQuestion.type = question.type
                    if question.type == "multiple" {
                        
                        let correctAnswer = Answer(context: coreDataService.managedObjectContext)
                        correctAnswer.answer2Question = newQuestion
                        correctAnswer.correct = true
                        correctAnswer.number = 1
                        correctAnswer.text = question.correct_answer
                        
                        var incorrectAnswerNo = 2
                        
                        for answer in question.incorrect_answers {
                            let incorrectAnswer = Answer(context: coreDataService.managedObjectContext)
                            incorrectAnswer.answer2Question = newQuestion
                            incorrectAnswer.correct = false
                            incorrectAnswer.number = Int16(incorrectAnswerNo)
                            incorrectAnswerNo += 1
                            incorrectAnswer.text = answer
                        }
                    } else {
                        
                        let rightAnswer = Answer(context: coreDataService.managedObjectContext)
                        rightAnswer.answer2Question = newQuestion
                        rightAnswer.correct = question.correct_answer == "True" ? true : false
                        rightAnswer.number = 1
                        let wrongAnswer = Answer(context: coreDataService.managedObjectContext)
                        wrongAnswer.answer2Question = newQuestion
                        wrongAnswer.correct = !rightAnswer.correct
                        wrongAnswer.number = 2
                    }
                }
                saveData(coreDataService: PersistenceController.shared)
            } catch {
                print("failure decoding json: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.networkErrorAlert = true
                }
            }
        } else {
            print("nil data returned from api")
            DispatchQueue.main.async {
                self.isLoading = false
                self.networkErrorAlert = true
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
    
    func getLoadedQuestions(coreDataService: PersistenceModule, completion: @escaping () -> Void) {
        
        DispatchQueue.main.async { [self] in
            questions = []
            let request: NSFetchRequest<Question> = Question.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "number", ascending: true)
            request.sortDescriptors = [sortDescriptor]
            do {
                questions = try coreDataService.managedObjectContext.fetch(request)
            } catch {
                print("error loading issues from CD: \(error)")
            }
            completion()
        }
    }
}
