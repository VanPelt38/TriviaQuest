//
//  TriviaQuestTests.swift
//  TriviaQuestTests
//
//  Created by Jake Gordon on 06/04/2024.
//

import XCTest
import SwiftUI
import CoreData
@testable import TriviaQuest

final class TriviaQuestTests: XCTestCase {
    
    
    //MARK: - Setup

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
       
    }
    

    //MARK: - All Questions View Tests
    
    // Load 15 Questions Tests
    
    
    // Persist Questions Tests
    
    
    // Save Data Tests
    
    
    // Get Loaded Data Tests
    
    
    //MARK: - Question View Tests
    
    // Set Answer Message Tests
    
    func testAnswerMessageReturnsCorrectly() {
        
        let questionView = QuestionView(number: 1)
        XCTAssertEqual(questionView.setAnswerMessage(false), Text("Better Luck Next Time...").foregroundColor(Color.red).bold())
    }
    
    // Set Answer Colour Tests
    
    func testAnswerColourReturnsDefaultBlue() {
        
        let questionView = QuestionView(number: 1)
        XCTAssertEqual(questionView.setAnswerColour(answerNo: 6), Color.blue)
    }
    
    // Get Question Tests
    
    
    // Save Data Tests
    
    func testDataSavesCorrectly() {
        
        let questionVM = QuestionViewModel()
        let testPersistence = TestPersistence.shared
        let newQuestion = Question(context: testPersistence.managedObjectContext)
        let testText = "CD Entity persisted correctly"
        newQuestion.text = testText
        questionVM.saveData(coreDataService: testPersistence)
        let request: NSFetchRequest<Question> = Question.fetchRequest()
        let predicate = NSPredicate(format: "text == %@", testText)
        request.predicate = predicate
        var result: [Question] = []
        do {
            result = try testPersistence.managedObjectContext.fetch(request)
        } catch {
            print("error loading issues from CD: \(error)")
        }
        XCTAssertEqual(result.first?.text, testText)
    }
    
    
    //MARK: - Network Manager Tests
    
    // Get 15 Questions Tests
    
    
}
