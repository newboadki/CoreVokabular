//
//  WordGeneratorTet.swift
//  CoreVokabular
//
//  Created by Borja Arias Drake on 13/03/15.
//  Copyright (c) 2015 Borja Arias Drake. All rights reserved.
//

import XCTest

class WordParserTests: XCTestCase
{
    
    let wordParser : WordParser = WordParser()
    let testInput = ["Krumpir:patatas", "Kruh:pan", "voće:fruta"]
    let fileManager = NSFileManager.defaultManager()
    
    
    override func setUp()
    {
        super.setUp()
        
        WordParser.deleteContentsOfImportedFiles()
        WordParser.createImportedFilesFolder()
    }
    
    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testStoreLinesIntoImportedFile() {
        
        let (success, fileName, error) = WordParser.storeLinesIntoImportedFile(testInput)
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let importedFilesPath = documentsPath.stringByAppendingPathComponent("vokabularImportedFiles")
        let filePath = importedFilesPath.stringByAppendingPathComponent(fileName)
        let contentData : NSData? = self.fileManager.contentsAtPath(filePath)
        let contentString = NSString(data: contentData!, encoding: NSUTF8StringEncoding) as String

        XCTAssert(success, "The imported file was not set")
        XCTAssert(contentString == "Krumpir:patatas\nKruh:pan\nvoće:fruta", "The file was not stored correctly")
    }
    
    
    func testParseWordsFromFileInfo()
    {
        var (success, fileName, error) = WordParser.storeLinesIntoImportedFile(testInput)
        
        let words = wordParser.parseWordsFromFileInfo(["displayName" : "TEST", "fileName": fileName, "imported" : "true"])
        
        XCTAssert(words.count == 3, "words were not parsed correctly")
        XCTAssert((words[0].name) == "Krumpir", "Krumpir name was not parsed")
        XCTAssert(words[0].synonyms.first == "patatas", "Krumpir synonym was not parsed")
        XCTAssert(words[1].name == "Kruh", "Krumpir name was not parsed")
        XCTAssert(words[1].synonyms.first == "pan", "pan synonym was not parsed")
        XCTAssert(words[2].name == "voće", "Krumpir name was not parsed")
        XCTAssert(words[2].synonyms.first == "fruta", "fruta synonym was not parsed")
    }

    
    func testparseWordsFromFileWithIndexKey()
    {
        let words = self.wordParser.parseWordsFromFileWithIndexKey("test")
        
        XCTAssert(words.count == 2, "words were not parsed correctly")
        XCTAssert((words[0].name) == "word1", "word1 name was not parsed")
        XCTAssert(words[0].synonyms.first == "correct", "word1 synonym was not parsed")
        XCTAssert(words[1].name == "word2", "word2 name was not parsed")
        XCTAssert(words[1].synonyms.first == "correct", "word2 synonym was not parsed")
    }
    
    func testLessonsIndexArrayWithIndexFileName()
    {
        let (success, fileName, error) = WordParser.storeLinesIntoImportedFile(testInput)
        let lessons = WordParser.lessonsIndexArrayWithIndexFileName("test-index")
        
        XCTAssert(lessons.count == 3, "There should be 3 lessons")
        XCTAssert(lessons[0] == ["displayName" : "Lekcija 6: Dođite k meni", "fileName": "lekcija6"], "There should be 3 lessons")
        XCTAssert(lessons[1] == ["displayName" : "Lekcija 8: Kakav stan imate", "fileName": "lekcija8"], "There should be 3 lessons")
        XCTAssert(lessons[2] == ["displayName" : fileName, "fileName": fileName, "imported" : "true"], "There should be 3 lessons")
        
        
    }

}
