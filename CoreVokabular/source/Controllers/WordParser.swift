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
    
    public class func lessonsIndexArrayWithIndexFileName(indexFileName : String) -> Array<[String : String]>
    {
        let bundle = NSBundle(forClass: self.classForCoder())
        let indexFilePath : NSString? = bundle.pathForResource(indexFileName, ofType: "plist")
        assert(indexFilePath != nil, "Couldn't load the index file")
        let defaultLessons = NSArray(contentsOfFile: indexFilePath as! String) as! Array<[String : String]>
        let importedLessons = WordParser.importedLessons()
        
        return (defaultLessons + importedLessons)
    }

    public func parseWordsFromFileInfo(fileInfo: Dictionary<String,String>) -> Array<Word>
    {
        let imported = fileInfo["imported"]
        let name = fileInfo["fileName"]
        var filePath : String

        if imported == "true"
        {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let importedFilesPath = NSURL(fileURLWithPath: documentsPath).URLByAppendingPathComponent("vokabularImportedFiles")
            let importedFilePath = NSURL(fileURLWithPath: importedFilesPath.path!).URLByAppendingPathComponent(name!)
            filePath = importedFilePath.path!
        }
        else
        {
            let bundle = NSBundle(forClass: self.dynamicType)
            let path : String? = bundle.pathForResource(name, ofType: wordListFileType)
            filePath = path!
        }
        
        return self.arrayOfWordsForFilePath(filePath)
    }
    
    
    // Consider moving these methods to FileManager or Filesystem class
    
    public class func storeLinesIntoImportedFile(lines : Array<String>) -> (Bool, String)
    {
        WordParser.createImportedFilesFolder()
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
        let components = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: date)
        let fileName = "imported\(components.year)\(components.month)\(components.day)\(components.hour)\(components.minute)\(components.second).txt"
        let filePath = NSURL(fileURLWithPath: importedFilesPath).URLByAppendingPathComponent(fileName)
        
        NSFileManager.defaultManager().createFileAtPath(filePath.path!, contents: fileText.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), attributes: nil)
        let success = NSFileManager.defaultManager().createFileAtPath(filePath.path!, contents: fileText.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), attributes: nil)
        return (success, fileName)
    }
    
    public class func deleteContentsOfImportedFiles() -> Bool
    {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let importedFilesPath = documentsPath.stringByAppendingPathComponent("vokabularImportedFiles")
        let fileManager = NSFileManager.defaultManager()

        
        var success = true

        do
        {
            try fileManager.removeItemAtPath(importedFilesPath)
        }
        catch {
            success = false
        }
        
        return success
    }
    
    
    public class func createImportedFilesFolder() -> Bool
    {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let importedFilesPath = documentsPath.stringByAppendingPathComponent("vokabularImportedFiles")
        let fileManager = NSFileManager.defaultManager()
        var isDirectory : ObjCBool = true
        let directoryExists = fileManager.fileExistsAtPath(importedFilesPath, isDirectory: &isDirectory)
        
        if !directoryExists
        {
            do
            {
                try fileManager.createDirectoryAtPath(importedFilesPath, withIntermediateDirectories: false, attributes: nil)
            }
            catch
            {
                
            }

            
        }
        
        return fileManager.fileExistsAtPath(importedFilesPath, isDirectory: &isDirectory)
    }

    
    // MARK: - Private
    
    func arrayOfWordsForFilePath(inputPath : String?) -> Array<Word>
    {
        var words = [Word]() // Creates an empty Array of Word(s)
        
        if let path = inputPath
        {
            let error : NSErrorPointer = nil
            let fileContent: String?
            do {
                fileContent = try String(contentsOfFile: path, encoding:NSUTF8StringEncoding)
            } catch let error1 as NSError {
                error.memory = error1
                fileContent = nil
            }
            let lines = fileContent?.componentsSeparatedByString("\n") // Returns an array of AnyObject
            
            for line in lines!
            {
                var lineComponents = line.componentsSeparatedByString(":")
                let name : String = lineComponents[0]
                let synonymsString : String = lineComponents[1]
                let synonyms = synonymsString.componentsSeparatedByString(",")
                let word = Word(name: name, synonyms: synonyms)
                words.append(word)
            }
        }
        
        return words
    }
    
    class func importedLessons() -> Array<[String : String]>
    {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let importedFilesPath = NSURL(fileURLWithPath: documentsPath).URLByAppendingPathComponent("vokabularImportedFiles")
        var lessons = [Dictionary<String,String>]()
        let fileManager = NSFileManager.defaultManager()
        let enumerator : NSDirectoryEnumerator? = fileManager.enumeratorAtPath(importedFilesPath.path!)

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
