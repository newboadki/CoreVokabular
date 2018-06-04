//
//  WordParser.swift
//  Vokabular
//
//  Created by Borja Arias Drake on 15/08/2014.
//  Copyright (c) 2014 Borja Arias Drake. All rights reserved.
//

import Foundation

public class WordParser
{
    public let wordListFileType = "txt"
    public let lessonsIndex : Array<Dictionary<String, String>>
    
    private static let importedFilesFolderName = "importedVokabularFiles"
    private static let kIndexFileName = "index"
    
    
    // MARK: - Initializers
    
    convenience public init() {
        let frameworkBundle = Bundle(for: WordParser.self)
        self.init(indexFileName: WordParser.kIndexFileName, bundle: frameworkBundle)
    }

    init(indexFileName: String, bundle: Bundle) {
        self.lessonsIndex = WordParser.lessonsIndexArray(withIndexFileName: indexFileName, inBundle: bundle)
    }

    
    
    // MARK: - Public API
    
    public func words(inLessonFile fileName: String, inBundle bundle: Bundle) -> [Word] {
        let lessonFilePath = bundle.path(forResource: fileName, ofType: wordListFileType)
        return self.arrayOfWordsForFilePath(lessonFilePath)
    }

    public func parseWordsFromFileInfo(_ fileInfo: Dictionary<String,String>) -> Array<Word>
    {
        let imported = fileInfo["imported"]
        let name = fileInfo["fileName"]
        var filePath : String

        if imported == "true"
        {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let importedFilesPath = URL(fileURLWithPath: documentsPath).appendingPathComponent(WordParser.importedFilesFolderName)
            let importedFilePath = URL(fileURLWithPath: importedFilesPath.path).appendingPathComponent(name!)
            filePath = importedFilePath.path
        }
        else
        {
            let bundle = Bundle(for: type(of: self))
            let path : String? = bundle.path(forResource: name, ofType: wordListFileType)
            filePath = path!
        }
        
        return self.arrayOfWordsForFilePath(filePath)
    }
}

// MARK: - Internal
internal extension WordParser {
    class func lessonsIndexArray(withIndexFileName indexFileName : String, inBundle bundle: Bundle) -> Array<[String : String]>
    {
        let indexFilePath = bundle.path(forResource: indexFileName, ofType: "plist")
        assert(indexFilePath != nil, "Couldn't load the index file")
        let defaultLessons = NSArray(contentsOfFile: indexFilePath!) as! Array<[String : String]>
        let importedLessons = WordParser.importedLessons()
        
        return (defaultLessons + importedLessons)
    }
}


// MARK: - Private
private extension WordParser {
    


    func arrayOfWordsForFilePath(_ inputPath : String?) -> Array<Word>
    {
        var words = [Word]() // Creates an empty Array of Word(s)
        
        if let path = inputPath
        {
            let error : NSErrorPointer? = nil
            let fileContent: String?
            do {
                fileContent = try String(contentsOfFile: path, encoding:String.Encoding.utf8)
            } catch let error1 as NSError {
                error??.pointee = error1
                fileContent = nil
            }
            let lines = fileContent?.components(separatedBy: "\n") // Returns an array of AnyObject
            
            for line in lines!
            {
                var lineComponents = line.components(separatedBy: ":")
                if lineComponents.count == 2 {
                    let name : String = lineComponents[0]
                    let synonymsString : String = lineComponents[1]
                    let synonyms = synonymsString.components(separatedBy: ",")
                    let word = Word(name: name, synonyms: synonyms)
                    words.append(word)
                }
            }
        }
        
        return words
    }
    

    
    class func importedLessons() -> Array<[String : String]>
    {
        let documentsDirectoryURL = FileSystemHelper.documentsDirectoryURL()
        let importedFilesPath = documentsDirectoryURL.appendingPathComponent(importedFilesFolderName).path
        var lessons = [Dictionary<String,String>]()
        let fileManager = FileManager.default
        let enumerator : FileManager.DirectoryEnumerator? = fileManager.enumerator(atPath: importedFilesPath)
        
        while let importedFile = enumerator?.nextObject() as? String
        {
            let dict : Dictionary<String,String> = ["displayName" : importedFile,
                                                    "fileName"    : importedFile,
                                                    "imported"    : "true"]
            lessons.append(dict)
        }
        
        return lessons
    }

}
