//
//  WordGenerator.swift
//  Vokabular
//
//  Created by Borja Arias Drake on 15/08/2014.
//  Copyright (c) 2014 Borja Arias Drake. All rights reserved.
//

import Foundation

/** 
- Consider make this class use value semantics 
- We could transform this class to conform to the GeneratorType protocol, and have a different class be the class conforming to SequenceType that would use this generator
    Basically An array of words would be the collection or sequence. And RandomWordGenerator would conform to GeneratorType
*/
public class WordGenerator: NSObject
{
    private let words : [Word]
    private let numberOfWordsToGenerate : Int
    private var currentIndex : Int = 0
    private var generatedWords : [Word]
    private var reachedEnd : Bool
    
//    var nextWord : Word?
//        {
//        get
//        {
//            if(self.currentIndex == self.numberOfWordsToGenerate)
//            {
//                self.reachedEnd = true
//                return nil
//            }
//            else
//            {
//                let word = self.generatedWords[self.currentIndex]
//                self.currentIndex = self.currentIndex + 1
//                return word
//            }
//        }
//    }
    
    
    var previousWord : Word?
        {
        get
        {
            if self.currentIndex <= 1 {
                return nil
            }
            
            if self.currentIndex > 1 {
                if self.reachedEnd {
                    let word = self.generatedWords[self.numberOfWordsToGenerate - 1]
                    return word
                } else {
                    let word = self.generatedWords[self.currentIndex - 2]
                    return word
                }
            }
            
            
            return nil
            
        }
    }
    
    public init(words: [Word], numberOfWordsToGenerate: Int)
    {
        self.words = words
        self.numberOfWordsToGenerate = numberOfWordsToGenerate
        self.generatedWords = [Word]()
        self.reachedEnd = false
        
        var generatedIndexes = [Int]()
        while (generatedIndexes.count < numberOfWordsToGenerate)
        {
            let randomIndex = Int(arc4random_uniform(UInt32(self.words.count)))
            if (!generatedIndexes.contains(randomIndex))
            {
                self.generatedWords.append(self.words[randomIndex])
                generatedIndexes.append(randomIndex)
            }
        }
    }
    
    public func nextWord() -> Word?
    {
        if(self.currentIndex == self.numberOfWordsToGenerate)
        {
            self.reachedEnd = true
            return nil
        }
        else
        {
            let word = self.generatedWords[self.currentIndex]
            self.currentIndex = self.currentIndex + 1
            return word
        }
    }

//    public func previousWord() -> Word?
//    {
//        if(self.currentIndex == 0)
//        {
//            return nil
//        }
//        else
//        {
//            let word = self.generatedWords[self.currentIndex - 1]
//            return word
//        }
//    }

}
