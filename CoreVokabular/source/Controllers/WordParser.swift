//
//  WordParser.swift
//  Vokabular
//
//  Created by Borja Arias Drake on 15/08/2014.
//  Copyright (c) 2014 Borja Arias Drake. All rights reserved.
//

import Foundation

public class WordParser : NSObject
{
    let wordListFileType = "txt"
    let index : NSArray
    
    // MARK: - Initializers
    
    public override init() {
        index = WordParser.lessonsIndexArrayWithIndexFileName("index")
        super.init()
    }
    
    // MARK: - Public API
    
    public func parseWordsFromFileWithIndexKey(indexKey: String) -> Array<Word>
    {
        let bundle = NSBundle(forClass: self.dynamicType)
        let path : String? = bundle.pathForResource(indexKey, ofType: wordListFileType)
        
        return self.arrayOfWordsForFilePath(path)
    }

    public func parseWordsFromFileInfo(fileInfo: Dictionary<String,String>) -> Array<Word>
    {
        let imported = fileInfo["imported"]
        let name = fileInfo["fileName"]
        var filePath : String

        if imported == "true"
        {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let importedFilesPath = documentsPath.stringByAppendingPathComponent("vokabularImportedFiles")
            let importedFilePath = importedFilesPath.stringByAppendingPathComponent(name!)
            filePath = importedFilePath
        }
        else
        {
            let bundle = NSBundle(forClass: self.dynamicType)
            let path : String? = bundle.pathForResource(name, ofType: wordListFileType)
            filePath = path!
        }
        
        return self.arrayOfWordsForFilePath(filePath)

    }

    public func parseWordsFromImportedFile(importedFileName: String) -> Array<Word>
    {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let filePath = documentsPath.stringByAppendingPathComponent(importedFileName)

        return self.arrayOfWordsForFilePath(filePath)
    }
    
    public class func lessonsIndexArrayWithIndexFileName(indexFileName : String) -> Array<[String : String]>
    {
        let bundle = NSBundle(forClass: self.classForCoder())
        let indexFilePath : NSString? = bundle.pathForResource(indexFileName, ofType: "plist")
        assert(indexFilePath != nil, "Couldn't load the index file")
        let defaultLessons = NSArray(contentsOfFile: indexFilePath as String) as Array<[String : String]>
        let importedLessons = WordParser.importedLessons()
        
        return (defaultLessons + importedLessons)
    }
    
    public class func storeLinesIntoImportedFile(lines : Array<String>) -> (Bool, String, NSErrorPointer)
    {
        let created = WordParser.createImportedFilesFolder()
        NSLog("CV: created directory: \(created)")

        
        var fileText = ""
        let lastString = lines.last
        
        for item in lines
        {
            if item == lastString
            {
                fileText = fileText.stringByAppendingString(item)
            }
            else
            {
                fileText = fileText.stringByAppendingFormat("\(item)\n")
            }
        }
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let importedFilesPath = documentsPath.stringByAppendingPathComponent("vokabularImportedFiles")
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth
         | .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond, fromDate: date)
        let fileName = "imported\(components.year)\(components.month)\(components.day)\(components.hour)\(components.minute)\(components.second).txt"
        let filePath = importedFilesPath.stringByAppendingPathComponent(fileName)
        
        if NSFileManager.defaultManager().isWritableFileAtPath(filePath) {
            println("File is writable")
        } else {
            println("File is read-only")
        }
        
        NSLog("CV ::: -> Trying to write at \(filePath)")
        var error : NSErrorPointer = nil
        NSFileManager.defaultManager().createFileAtPath(filePath, contents: fileText.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), attributes: nil)
        let success = NSFileManager.defaultManager().createFileAtPath(filePath, contents: fileText.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), attributes: nil)//fileText.writeToFile(filePath, atomically: false, encoding: NSUTF8StringEncoding, error: error)
        if error != nil
        {
            NSLog("CV ::: -> Error:\(error)")
        }
        else
        {
            NSLog("CV ::: -> NO ERROR")
        }
        
        NSLog("CV ::: -> Success:\(success)")
        return (success, fileName, error)
    }
    
    public class func deleteContentsOfImportedFiles() -> Bool
    {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let importedFilesPath = documentsPath.stringByAppendingPathComponent("vokabularImportedFiles")
        let fileManager = NSFileManager.defaultManager()
        var error : NSErrorPointer = nil
        
        let success = fileManager.removeItemAtPath(importedFilesPath, error: error)
        NSLog("ERROR DELETING \(error)")
        return success
    }
    
    
    public class func createImportedFilesFolder() -> Bool
    {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let importedFilesPath = documentsPath.stringByAppendingPathComponent("vokabularImportedFiles")
        let fileManager = NSFileManager.defaultManager()
        var error : NSErrorPointer = nil
        var isDirectory : ObjCBool = true
        var directoryExists = fileManager.fileExistsAtPath(importedFilesPath, isDirectory: &isDirectory)
        
        if !directoryExists
        {
            fileManager.createDirectoryAtPath(importedFilesPath, withIntermediateDirectories: false, attributes: nil, error: error)
        }
        
        return fileManager.fileExistsAtPath(importedFilesPath, isDirectory: &isDirectory)
    }

    
    // MARK: - Private
    
    func arrayOfWordsForFilePath(inputPath : String?) -> Array<Word>
    {
        var words = [Word]() // Creates an empty Array of Word(s)
        
        if let path = inputPath
        {
            NSLog("CV -> input path: \(path)")
            var error : NSErrorPointer = nil
            let fileContent = String(contentsOfFile: path, encoding:NSUTF8StringEncoding, error: error)
            let lines = fileContent?.componentsSeparatedByString("\n") // Returns an array of AnyObject
            
            for line in lines!
            {
                NSLog("CV -> w: \(line)")
                var lineComponents = line.componentsSeparatedByString(":")
                var name : String = lineComponents[0]
                var synonymsString : String = lineComponents[1]
                var synonyms = synonymsString.componentsSeparatedByString(",")
                var word = Word(name: name, synonyms: synonyms)
                words.append(word)
            }
        }
        
        return words
    }
    
    class func importedLessons() -> Array<[String : String]>
    {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let importedFilesPath = documentsPath.stringByAppendingPathComponent("vokabularImportedFiles")
        var lessons = [Dictionary<String,String>]()
        var error : NSErrorPointer = nil
        let fileManager = NSFileManager.defaultManager()
        let enumerator : NSDirectoryEnumerator? = fileManager.enumeratorAtPath(importedFilesPath)

        while let importedFile = enumerator?.nextObject() as? String
        {
            var dict : Dictionary<String,String> = ["displayName" : importedFile,
                                                    "fileName"    : importedFile,
                                                    "imported"    : "true"]
            lessons.append(dict)
        }
        
        return lessons
    }

}
