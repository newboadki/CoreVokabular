//
//  WordGeneratorTests.swift
//  CoreVokabular
//
//  Created by Borja Arias Drake on 04/03/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//

import XCTest
@testable import CoreVokabular


class WordGeneratorTests: XCTestCase {

    var generator : WordGenerator!
    var words: [Word]!
    
    override func setUp() {
        super.setUp()
        let testBundle = Bundle(for: type(of: self))
        let wordParser : WordParser = WordParser(indexFileName: "test-index", bundle: testBundle)
        words = wordParser.words(inLessonFile: "lekcija6", inBundle: testBundle)
        self.generator = WordGenerator(words: words, numberOfWordsToGenerate: words.count)
    }
    
    func testPreviousWordIsNilInitially()
    {
        XCTAssertNil(self.generator?.previousWord, "The firt time, previous word must be nil")
    }
    
    func testWordCountIsCorrectWhenWordsProvided()
    {
        XCTAssertTrue(self.generatedWordsCount() == words.count, "The generator didn't go through all the words")
    }

    func testWordCountIsCorrectWhenNoWordsProvided()
    {
        self.generator = WordGenerator(words: [Word](), numberOfWordsToGenerate: words.count)
        XCTAssertTrue(self.generatedWordsCount() == 0, "If no words provided there should not be any generated words")
    }

    func testAllWordsAreReturned() {
        while let w = self.generator.nextWord() {
            XCTAssertTrue(words.contains(w), "Not all words are returned by the generator")
        }
    }
    
    func testPreviousWord() {
        var previous: Word? = nil
        while let w = self.generator.nextWord() {
            XCTAssertEqual(self.generator.previousWord, previous, "Previous word logic is not working")
            previous = w
        }
    }
}

private extension WordGeneratorTests {
    
    func generatedWordsCount() -> Int {
        var count = 0
        while (self.generator.nextWord() != nil) {
            count += 1
        }
        
        return count
    }
}
