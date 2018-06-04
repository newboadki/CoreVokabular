//
//  TestExecutionManagerTests.swift
//  CoreVokabular
//
//  Created by Borja Arias Drake on 11/11/2014.
//  Copyright (c) 2014 Borja Arias Drake. All rights reserved.
//

import XCTest
@testable import CoreVokabular

class TestExecutionManagerTests: XCTestCase, TestExecutionDelegate {

    var executionManager : TestExecutionManager?
    
    override func setUp()
    {
        super.setUp()
        let testBundle = Bundle(for: type(of: self))
        self.executionManager = TestExecutionManager(delegate: self, selectedLesson: ["displayName" : "TEST", "fileName": "test", "imported" : "false"], indexFileName: "test-index", bundle: testBundle)
    
    }
    
    override func tearDown()
    {
        super.tearDown()
    }

    func testCount()
    {
        let word = self.executionManager?.initialWord()
        XCTAssertTrue(word != nil, "")
        
        self.executionManager!.processGivenAnswer("wrong")
        XCTAssert(self.executionManager?.count == 1, "")
        XCTAssert(self.executionManager?.numberOfCorrectAnswers == 0, "")
        
        self.executionManager!.processGivenAnswer("correct")
        XCTAssert(self.executionManager?.count == 2, "")
        XCTAssert(self.executionManager?.numberOfCorrectAnswers == 0, "")

        self.executionManager!.processGivenAnswer("correct")
        XCTAssert(self.executionManager?.count == 2, "")
        XCTAssert(self.executionManager?.numberOfCorrectAnswers == 1, "")
    }
    
    // DELEGATE
    func handleCorrectAnswerWithNextWord(_ word : Word?) {}
    func handleFailedAttemptWithCorrectAnswer(_ correctAnswer : String) {}
}
