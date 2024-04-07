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
    
    func testPersistQuestionsHandlesNilData() {
        
        let allQuestionsVM = AllQuestionsViewModel()
        let testPersistence = TestPersistence.shared
        let expectation = XCTestExpectation(description: "network error alert = true")
        allQuestionsVM.persistQuestions(questionData: nil, coreDataService: testPersistence)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(allQuestionsVM.networkErrorAlert)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testPersistQuestionsSavesCorrectly() {
        
        let allQuestionsVM = AllQuestionsViewModel()
        let testPersistence = TestPersistence.shared

        let bundle = Bundle(for: TriviaQuestTests.self)
            guard let url = bundle.url(forResource: "testJSONResponse", withExtension: "json"),
                  let jsonData = try? Data(contentsOf: url) else {
                fatalError("Failed to load mock JSON data")
            }
        allQuestionsVM.persistQuestions(questionData: jsonData, coreDataService: testPersistence)
        let request: NSFetchRequest<Question> = Question.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "number", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        var results: [Question] = []
        do {
            results = try testPersistence.managedObjectContext.fetch(request)
        } catch {
            print("error loading issues from CD: \(error)")
        }
        XCTAssertEqual(results[0].text, "What does a funambulist walk on?")
        XCTAssertEqual(results[1].text, "Which of these is not an additional variation of the color purple?")
    }
    
    // Save Data Tests
    
    func testDataSavesCorrectlyAllQuestions() {
        
        let questionVM = AllQuestionsViewModel()
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

    
    // Get Loaded Data Tests
    
    func testGetLoadedQuestionsReturnsQuestions() {
        
        let allQuestionsVM = AllQuestionsViewModel()
        let testPersistence = TestPersistence.shared
        let newQuestion = Question(context: testPersistence.managedObjectContext)
        newQuestion.number = 5
        do {
            try testPersistence.managedObjectContext.save()
        } catch {
            print("error saving CD: \(error)")
        }
        allQuestionsVM.getLoadedQuestions(coreDataService: testPersistence) {
            XCTAssertEqual(allQuestionsVM.questions.first?.number, 5)
        }
    }
    
    func testGetLoadedQuestionsSortsQuestions() {
        
        let allQuestionsVM = AllQuestionsViewModel()
        let testPersistence = TestPersistence.shared
        let newQuestion = Question(context: testPersistence.managedObjectContext)
        newQuestion.number = 5
        let newQuestion2 = Question(context: testPersistence.managedObjectContext)
        newQuestion2.number = 8
        let newQuestion3 = Question(context: testPersistence.managedObjectContext)
        newQuestion3.number = 6
        do {
            try testPersistence.managedObjectContext.save()
        } catch {
            print("error saving CD: \(error)")
        }
        allQuestionsVM.getLoadedQuestions(coreDataService: testPersistence) {
            XCTAssertEqual(allQuestionsVM.questions.map { $0.number }, [5, 6, 8])
        }
    }
    
    
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
    
    func testGetQuestionLoadsQuestion() {
        
        let questionVM = QuestionViewModel()
        let testPersistence = TestPersistence.shared
        let newQuestion = Question(context: testPersistence.managedObjectContext)
        newQuestion.number = 5
        do {
            try testPersistence.managedObjectContext.save()
        } catch {
            print("error saving CD: \(error)")
        }
        questionVM.getQuestion(5, coreDataService: testPersistence)
        XCTAssertEqual(questionVM.question.first?.number, 5)
    }
    
    // Save Data Tests
    
    func testDataSavesCorrectlyQuestion() {
        
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
