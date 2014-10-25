//
//  WordParser.swift
//  Vokabular
//
//  Created by Borja Arias Drake on 15/08/2014.
//  Copyright (c) 2014 Borja Arias Drake. All rights reserved.
//

import UIKit

public class WordParser : NSObject
{
    let wordListFileType = "txt"
    let indexDictionary : NSDictionary
    
    
    public override init() {
        indexDictionary = WordParser.lessonsIndexDictionary()
        super.init()
    }
    
    public func parseWordsFromFileWithIndexKey(indexKey: String) -> Array<Word>
    {
        
        let path : NSString? = NSBundle.mainBundle().pathForResource(indexKey, ofType: wordListFileType)
        var error : NSErrorPointer = nil
        var words = [Word]() // Creates an empty Array of Word(s)
        
        if (path != nil)
        {
            let fileContent = String(contentsOfFile: path!, encoding:NSUTF8StringEncoding, error: error)
            let lines = fileContent?.componentsSeparatedByString("\n") // Returns an array of AnyObject
            
            for line in lines!
            {
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
    
    
    public class func lessonsIndexDictionary() -> NSDictionary
    {
        let indexFilePath : NSString? = NSBundle.mainBundle().pathForResource("index", ofType: "plist")
        assert(indexFilePath != nil, "Couldn't load the index file")
        let dictionry = NSDictionary(contentsOfFile: indexFilePath!)
        
        return dictionry!
    }
    
}
