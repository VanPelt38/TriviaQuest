//
//  TriviaResultsModel.swift
//  TriviaQuest
//
//  Created by Jake Gordon on 06/04/2024.
//

import Foundation

struct TriviaResultsModel: Codable {
    
    let response_code: Int
    let results: [QuestionModel]
}
