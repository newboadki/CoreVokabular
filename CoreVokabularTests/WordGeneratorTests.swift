//
//  WordGeneratorTests.swift
//  CoreVokabular
//
//  Created by Borja Arias Drake on 04/03/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import XCTest

class WordGeneratorTests: XCTestCase {

    var generator : WordGenerator?
    
    override func setUp() {
        super.setUp()
        
        let wordParser : WordParser = WordParser()
        let testInput = ["Krumpir:patatas", "Kruh:pan", "voće:fruta"]
        let (_, fileName) = WordParser.storeLinesIntoImportedFile("title.txt", lines: testInput)
        let words = wordParser.parseWordsFromFileInfo(["displayName" : "TEST", "fileName": fileName, "imported" : "true"])

        self.generator = WordGenerator(words: words, numberOfWordsToGenerate: words.count)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPreviousWord()
    {
        XCTAssertNil(self.generator?.previousWord, "The firt time, previou ord mut be nil")

        XCTAssertEqual(self.generator?.nextWord()?.name, "Krumpir", "The firt time, previou ord mut be nil")
        XCTAssertNil(self.generator?.previousWord, "The firt time, previou ord mut be nil")
        
        XCTAssertEqual(self.generator?.nextWord()?.name, "Kruh", "The firt time, previou ord mut be nil")
        XCTAssertEqual(self.generator?.previousWord?.name, "Krumpir", "The firt time, previou ord mut be nil")

        XCTAssertEqual(self.generator?.nextWord()?.name, "voće", "The firt time, previou ord mut be nil")
        XCTAssertEqual(self.generator?.previousWord?.name, "Kruh", "The firt time, previou ord mut be nil")
        
        XCTAssertNil(self.generator?.nextWord, "The firt time, previou ord mut be nil")
        XCTAssertEqual(self.generator?.previousWord?.name, "voće", "The firt time, previou ord mut be nil")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
