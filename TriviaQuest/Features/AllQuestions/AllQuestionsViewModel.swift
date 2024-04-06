//
//  AllQuestionsViewModel.swift
//  TriviaQuest
//
//  Created by Jake Gordon on 06/04/2024.
//

import Foundation

class AllQuestionsViewModel: ObservableObject {
    

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
                print("this is result: \(result)")
                for question in result.results {
                    print(question.category)
                }
            } catch {
                print("failure decoding json: \(error)")
            }
            
        }
    }
}
