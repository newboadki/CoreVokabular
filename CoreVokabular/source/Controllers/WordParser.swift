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
    
    
    public override init() {
        index = WordParser.lessonsIndexArray()
        super.init()
    }
    
    public func parseWordsFromFileWithIndexKey(indexKey: String) -> Array<Word>
    {
        let bundle = NSBundle(forClass: self.dynamicType)
        let path : String? = bundle.pathForResource(indexKey, ofType: wordListFileType)
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
    
    
    public class func lessonsIndexArray() -> NSArray
    {
        let bundle = NSBundle(forClass: self.classForCoder())
        let indexFilePath : NSString? = bundle.pathForResource("index", ofType: "plist")
        assert(indexFilePath != nil, "Couldn't load the index file")
        let array = NSArray(contentsOfFile: indexFilePath! as! String)
        
        return array!
    }
    
}
