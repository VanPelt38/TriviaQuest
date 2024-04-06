//
//  AllQuestionsViewModel.swift
//  TriviaQuest
//
//  Created by Jake Gordon on 06/04/2024.
//

import Foundation

class AllQuestionsViewModel: ObservableObject {
    

    func load15Questions(networkManager: NetworkManagerModule) {
        networkManager.get15Questions()
    }
}
