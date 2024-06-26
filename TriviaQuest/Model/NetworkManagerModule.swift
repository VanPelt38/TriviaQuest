//
//  NetworkManagerModule.swift
//  TriviaQuest
//
//  Created by Jake Gordon on 06/04/2024.
//

import Foundation

protocol NetworkManagerModule {
    func get15Questions() async throws -> Data?
}
