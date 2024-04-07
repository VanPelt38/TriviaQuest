//
//  NetworkManager.swift
//  TriviaQuest
//
//  Created by Jake Gordon on 06/04/2024.
//

import Foundation

class NetworkManager: NetworkManagerModule {
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func get15Questions() async throws -> Data? {

        guard let triviaURL = URL(string: "https://opentdb.com/api.php?amount=15") else { throw URLError(.badURL) }
        let (data, _) = try await session.data(for: URLRequest(url: triviaURL))
        
           return data
        }
}
