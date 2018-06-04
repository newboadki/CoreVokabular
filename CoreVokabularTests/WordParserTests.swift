//
//  WordGeneratorTet.swift
//  CoreVokabular
//
//  Created by Borja Arias Drake on 13/03/15.
//  Copyright (c) 2015 Borja Arias Drake. All rights reserved.
//

import XCTest
@testable import CoreVokabular

class WordParserTests: XCTestCase
{    
    var wordParser : WordParser!
    let testInput = ["Krumpir:patatas", "Kruh:pan", "voće:fruta"]
    let fileManager = FileManager.default
    let importedFilesFolderName = "importedVokabularFiles"
    
    override func setUp()
    {
        super.setUp()
        
        let bundle = Bundle(for: self.classForCoder)
        self.wordParser = WordParser(indexFileName: "test-index", bundle: bundle)
        let _ = FileSystemHelper.deleteContentsOf(directoryName: importedFilesFolderName)
        let _ = FileSystemHelper.create(directoryName: importedFilesFolderName)
    }
    
    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testStoreLinesIntoImportedFile() {
        
        let (success, fileName) = FileSystemHelper.storeLinesIntoImportedFile("title.txt", lines: testInput, directoryName: importedFilesFolderName)
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let importedFilesPath = documentsPath + "/importedVokabularFiles"
        let filePath = URL(fileURLWithPath: importedFilesPath).appendingPathComponent(fileName)
        let contentData : Data? = self.fileManager.contents(atPath: filePath.path)
        let contentString = NSString(data: contentData!, encoding: String.Encoding.utf8.rawValue)

        XCTAssert(success, "The imported file was not set")
        XCTAssert(contentString == "Krumpir:patatas\nKruh:pan\nvoće:fruta", "The file was not stored correctly")
    }
    
    
    func testParseWordsFromFileInfo()
    {
        let (_, fileName) = FileSystemHelper.storeLinesIntoImportedFile("title.txt", lines: testInput, directoryName: importedFilesFolderName)
        let words = wordParser.parseWordsFromFileInfo(["displayName" : "TEST", "fileName": fileName, "imported" : "true"])
        
        XCTAssert(words.count == 3, "words were not parsed correctly")
        XCTAssert((words[0].name) == "Krumpir", "Krumpir name was not parsed")
        XCTAssert(words[0].synonyms.first == "patatas", "Krumpir synonym was not parsed")
        XCTAssert(words[1].name == "Kruh", "Krumpir name was not parsed")
        XCTAssert(words[1].synonyms.first == "pan", "pan synonym was not parsed")
        XCTAssert(words[2].name == "voće", "Krumpir name was not parsed")
        XCTAssert(words[2].synonyms.first == "fruta", "fruta synonym was not parsed")
    }
    
    func testLessonsIndexArrayWithIndexFileName()
    {
        let (_, fileName) = FileSystemHelper.storeLinesIntoImportedFile("title", lines: testInput, directoryName: importedFilesFolderName)
        let testBundle = Bundle(for: self.classForCoder)
        let lessons = WordParser.lessonsIndexArray(withIndexFileName: "test-index", inBundle: testBundle)
        
        XCTAssert(lessons.count == 3, "There should be 3 lessons")
        XCTAssert(lessons[0] == ["displayName" : "Lekcija 6: Dođite k meni", "fileName": "lekcija6"], "There should be 3 lessons")
        XCTAssert(lessons[1] == ["displayName" : "Lekcija 8: Kakav stan imate", "fileName": "lekcija8"], "There should be 3 lessons")
        XCTAssert(lessons[2] == ["displayName" : fileName, "fileName": fileName, "imported" : "true"], "There should be 3 lessons")
    }
}
