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
       
        let testPersistence = TestPersistence.shared
        let request: NSFetchRequest<Question> = Question.fetchRequest()
        do {
            let questions = try testPersistence.managedObjectContext.fetch(request)
            for q in questions {
                testPersistence.managedObjectContext.delete(q as NSManagedObject)
            }
            try testPersistence.managedObjectContext.save()
        } catch {
            fatalError("Error deleting question objects")
        }
    }
    

    //MARK: - All Questions View Tests
    
    // Filter Difficulty Tests
    
    func testSearchFilterReturnsCorrectlyWithoutText() {
        
        let allQuestionsView = AllQuestionsView()
        let testPersistence = TestPersistence.shared
        let question = Question(context: testPersistence.managedObjectContext)
        question.text = "This question has text"
        do {
            try testPersistence.managedObjectContext.save()
        } catch {
            print("failed to save entities: \(error)")
        }
        XCTAssertTrue(allQuestionsView.searchFilter(with: question, and: ""))
    }
    
    func testSearchFilterReturnsCorrectlyWithText() {
        
        let allQuestionsView = AllQuestionsView()
        let testPersistence = TestPersistence.shared
        let question = Question(context: testPersistence.managedObjectContext)
        question.text = "This question has text"
        do {
            try testPersistence.managedObjectContext.save()
        } catch {
            print("failed to save entities: \(error)")
        }
        XCTAssertTrue(allQuestionsView.searchFilter(with: question, and: "question"))
    }
    
    // Load 15 Questions Tests
    
    func testLoad15QuestionsLoadsOnFirstLaunch() {
        
        let allQuestionsVM = AllQuestionsViewModel()
        let testPersistence = TestPersistence.shared
        let testNetworkManager = TestNetworkManager()
        let expectation = XCTestExpectation(description: "questions are loaded")
        let bundle = Bundle(for: TriviaQuestTests.self)
            guard let url = bundle.url(forResource: "testJSONResponse", withExtension: "json"),
                  let jsonData = try? Data(contentsOf: url) else {
                fatalError("Failed to load mock JSON data")
            }
        testNetworkManager.testData = jsonData
        Task.init {
            await allQuestionsVM.load15Questions(networkManager: testNetworkManager, coreDataService: testPersistence)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                XCTAssertEqual(allQuestionsVM.questions[0].difficulty, "easy")
                XCTAssertEqual(allQuestionsVM.questions[1].difficulty, "medium")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testLoad15QuestionsSubsequentLoads() {
        
        let allQuestionsVM = AllQuestionsViewModel()
        let testPersistence = TestPersistence.shared
        let testNetworkManager = TestNetworkManager()
        let newQuestion1 = Question(context: testPersistence.managedObjectContext)
        let testText = "CD Entity 1 persisted correctly"
        newQuestion1.text = testText
        let newQuestion2 = Question(context: testPersistence.managedObjectContext)
        let testText2 = "CD Entity 2 persisted correctly"
        newQuestion2.text = testText2
        do {
            try testPersistence.managedObjectContext.save()
        } catch {
            print("failed to save entities: \(error)")
        }
        let expectation = XCTestExpectation(description: "questions are loaded")
        Task.init {
            await allQuestionsVM.load15Questions(networkManager: testNetworkManager, coreDataService: testPersistence)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                XCTAssertEqual(allQuestionsVM.questions[0].text, testText)
                XCTAssertEqual(allQuestionsVM.questions[1].text, testText2)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    // Persist Questions Tests
    
    func testPersistQuestionsHandlesNilData() {
        
        let allQuestionsVM = AllQuestionsViewModel()
        let testPersistence = TestPersistence.shared
        let expectation = XCTestExpectation(description: "network error alert = true")
        allQuestionsVM.persistQuestions(questionData: nil, coreDataService: testPersistence)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(allQuestionsVM.networkErrorAlert)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
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
    
    func testGet15QuestionsSuccessResponse() {
        
        let testNetworkManager = TestNetworkManager()
        let bundle = Bundle(for: TriviaQuestTests.self)
            guard let url = bundle.url(forResource: "testJSONResponse", withExtension: "json"),
                  let jsonData = try? Data(contentsOf: url) else {
                fatalError("Failed to load mock JSON data")
            }
        testNetworkManager.testData = jsonData
        Task.init {
            let result = try await testNetworkManager.get15Questions()
            XCTAssertEqual(result, jsonData)
        }
    }
    
    func testGet15QuestionsErrorResponse() {
        
        let testNetworkManager = TestNetworkManager()
        let bundle = Bundle(for: TriviaQuestTests.self)
            guard let url = bundle.url(forResource: "testJSONResponse", withExtension: "json"),
                  let jsonData = try? Data(contentsOf: url) else {
                fatalError("Failed to load mock JSON data")
            }
        testNetworkManager.testData = jsonData
        testNetworkManager.shouldThrowError = true
        Task.init {
            do {
                let _ = try await testNetworkManager.get15Questions()
                XCTFail("Expected error to be thrown but it succeeded")
            } catch let error as NSError {
                XCTAssertEqual(error.domain, "")
                XCTAssertEqual(error.code, 0)
            }
        }
    }
}
