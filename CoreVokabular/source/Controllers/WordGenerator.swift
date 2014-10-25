//
//  WordGenerator.swift
//  Vokabular
//
//  Created by Borja Arias Drake on 15/08/2014.
//  Copyright (c) 2014 Borja Arias Drake. All rights reserved.
//

import UIKit
import Foundation

public class WordGenerator: NSObject
{
    
    let words : [Word]
    let numberOfWordsToGenerate : Int
    var currentIndex : Int = 0
    var generatedWords : [Word]
    
    
    public init(words: [Word], numberOfWordsToGenerate: Int)
    {
        self.words = words
        self.numberOfWordsToGenerate = numberOfWordsToGenerate
        self.generatedWords = [Word]()
        
        var generatedIndexes = [Int]()
        while (generatedIndexes.count < numberOfWordsToGenerate)
        {
            var randomIndex = Int(arc4random_uniform(UInt32(self.words.count)))
            if (!contains(generatedIndexes, randomIndex))
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
            return nil
        }
        else
        {
            var word = self.generatedWords[self.currentIndex]
            self.currentIndex = self.currentIndex + 1
            return word
        }
    }
    
}
