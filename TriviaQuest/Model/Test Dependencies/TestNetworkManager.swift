//
//  TestNetworkManager.swift
//  TriviaQuest
//
//  Created by Jake Gordon on 07/04/2024.
//

import Foundation

class TestNetworkManager: NetworkManagerModule {
    
    var testData: Data?
    var shouldThrowError: Bool = false
    
    func get15Questions() async throws -> Data? {
        if shouldThrowError {
            throw NSError(domain: "", code: 0)
        }
        return testData
    }
}
