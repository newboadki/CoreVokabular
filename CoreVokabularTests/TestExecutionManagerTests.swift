//
//  TestExecutionManagerTests.swift
//  CoreVokabular
//
//  Created by Borja Arias Drake on 11/11/2014.
//  Copyright (c) 2014 Borja Arias Drake. All rights reserved.
//

import XCTest

class TestExecutionManagerTests: XCTestCase, TestExecutionDelegate {

    var executionManager : TestExecutionManager?
    
    override func setUp()
    {
        super.setUp()
        self.executionManager = TestExecutionManager(delegate: self, selectedLesson: ["displayName" : "TEST", "fileName": "test"])
    
    }
    
    override func tearDown()
    {
        super.tearDown()
    }

    func testCount()
    {
        var word = self.executionManager?.initialWord()
        XCTAssertTrue(word != nil, "")
        
        self.executionManager!.processGivenAnswer("wrong")
        XCTAssert(self.executionManager?.count == 1, "")
        XCTAssert(self.executionManager?.numberOfCorrectAnswers == 0, "")
        
        self.executionManager!.processGivenAnswer("correct")
        XCTAssert(self.executionManager?.count == 2, "")
        XCTAssert(self.executionManager?.numberOfCorrectAnswers == 0, "")

        self.executionManager!.processGivenAnswer("correct")
        XCTAssert(self.executionManager?.count == 3, "")
        XCTAssert(self.executionManager?.numberOfCorrectAnswers == 1, "")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    // DELEGATE
    func handleCorrectAnswerWithNextWord(word : Word?) {}
    func handleFailedAttemptWithCorrectAnswer(correctAnswer : String) {}
}
