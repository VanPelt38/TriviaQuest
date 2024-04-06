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
  
        }
    }
}
