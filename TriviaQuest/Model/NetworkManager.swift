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
    
    func get15Questions() {

        guard let triviaURL = URL(string: "https://opentdb.com/api.php?amount=15") else { return }
        let task = session.dataTask(with: triviaURL) { (data, response, error) in
            
            if let e = error {
                print("error retrieving 15 questions: \(e)")
                return
            }
            if let response = data {
                if let jsonString = String(data: response, encoding: .utf8) {
                    print("result \(jsonString)")
                }
            }
        }
        task.resume()
    }
}
