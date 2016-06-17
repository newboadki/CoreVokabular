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
    
    public class func lessonsIndexArrayWithIndexFileName(_ indexFileName : String) -> Array<[String : String]>
    {
        let bundle = Bundle(for: self.classForCoder())
        let indexFilePath : NSString? = bundle.pathForResource(indexFileName, ofType: "plist")
        assert(indexFilePath != nil, "Couldn't load the index file")
        let defaultLessons = NSArray(contentsOfFile: indexFilePath as! String) as! Array<[String : String]>
        let importedLessons = WordParser.importedLessons()
        
        return (defaultLessons + importedLessons)
    }

    public func parseWordsFromFileInfo(_ fileInfo: Dictionary<String,String>) -> Array<Word>
    {
        let imported = fileInfo["imported"]
        let name = fileInfo["fileName"]
        var filePath : String

        if imported == "true"
        {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let importedFilesPath = try! URL(fileURLWithPath: documentsPath).appendingPathComponent("vokabularImportedFiles")
            let importedFilePath = try! URL(fileURLWithPath: importedFilesPath.path!).appendingPathComponent(name!)
            filePath = importedFilePath.path!
        }
        else
        {
            let bundle = Bundle(for: self.dynamicType)
            let path : String? = bundle.pathForResource(name, ofType: wordListFileType)
            filePath = path!
        }
        
        return self.arrayOfWordsForFilePath(filePath)
    }
    
    
    // Consider moving these methods to FileManager or Filesystem class
    
    public class func storeLinesIntoImportedFile(_ title : String?, lines : Array<String>) -> (Bool, String)
    {
        WordParser.createImportedFilesFolder()
        var fileText = ""
        let lastString = lines.last
        
        for item in lines
        {
            if item == lastString
            {
                fileText = fileText + item
            }
            else
            {
                fileText = fileText.appendingFormat("\(item)\n")
            }
        }
        
        let fileName :  String
        let date = Date()
        let calendar = Calendar.current()
        let components = calendar.components([.year, .month, .day, .hour, .minute, .second], from: date)
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let importedFilesPath = documentsPath.appendingPathComponent("vokabularImportedFiles")

        if let name = title {
           fileName = "\(name).txt"
        } else {
            fileName = "imported\(components.year)\(components.month)\(components.day)\(components.hour)\(components.minute)\(components.second).txt"
        }
        

        let filePath = try! URL(fileURLWithPath: importedFilesPath).appendingPathComponent(fileName)
        
        FileManager.default().createFile(atPath: filePath.path!, contents: fileText.data(using: String.Encoding.utf8, allowLossyConversion: false), attributes: nil)
        let success = FileManager.default().createFile(atPath: filePath.path!, contents: fileText.data(using: String.Encoding.utf8, allowLossyConversion: false), attributes: nil)
        return (success, fileName)
    }
    
    public class func deleteContentsOfImportedFiles() -> Bool
    {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let importedFilesPath = documentsPath.appendingPathComponent("vokabularImportedFiles")
        let fileManager = FileManager.default()
        
        var success = true

        do
        {
            try fileManager.removeItem(atPath: importedFilesPath)
        }
        catch {
            success = false
        }
        
        return success
    }
    
    
    public class func createImportedFilesFolder() -> Bool
    {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let importedFilesPath = documentsPath.appendingPathComponent("vokabularImportedFiles")
        let fileManager = FileManager.default()
        var isDirectory : ObjCBool = true
        let directoryExists = fileManager.fileExists(atPath: importedFilesPath, isDirectory: &isDirectory)
        
        if !directoryExists
        {
            do
            {
                try fileManager.createDirectory(atPath: importedFilesPath, withIntermediateDirectories: false, attributes: nil)
            }
            catch
            {
                
            }

            
        }
        
        return fileManager.fileExists(atPath: importedFilesPath, isDirectory: &isDirectory)
    }

    
    // MARK: - Private
    
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
                let name : String = lineComponents[0]
                let synonymsString : String = lineComponents[1]
                let synonyms = synonymsString.components(separatedBy: ",")
                let word = Word(name: name, synonyms: synonyms)
                words.append(word)
            }
        }
        
        return words
    }
    
    class func importedLessons() -> Array<[String : String]>
    {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let importedFilesPath = try! URL(fileURLWithPath: documentsPath).appendingPathComponent("vokabularImportedFiles")
        var lessons = [Dictionary<String,String>]()
        let fileManager = FileManager.default()
        let enumerator : FileManager.DirectoryEnumerator? = fileManager.enumerator(atPath: importedFilesPath.path!)

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
