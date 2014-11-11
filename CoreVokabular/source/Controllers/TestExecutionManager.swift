//
//  TestExecutionManager.swift
//  CoreVokabular
//
//  Created by Borja Arias Drake on 01/11/2014.
//  Copyright (c) 2014 Borja Arias Drake. All rights reserved.
//

import Foundation

public protocol TestExecutionDelegate
{
    func handleCorrectAnswerWithNextWord(word : Word?)
    func handleFailedAttemptWithCorrectAnswer(correctAnswer : String)
    
}

public class TestExecutionManager
{
    // Components
    var wordGenerator : WordGenerator?
    
    // State
    public var currentWord : Word?
    public var numberOfCorrectAnswers : Int = 0
    public var count : Int = 1
    public var total : Int = 0
    public var selectedLesson : Dictionary<String, String>
    
    var previousWord : Word?
    var delegate : TestExecutionDelegate
    
    
    public init(delegate : TestExecutionDelegate, selectedLesson :Dictionary<String, String> )
    {
        var parser = WordParser()
        self.selectedLesson = selectedLesson
        var words = parser.parseWordsFromFileWithIndexKey(self.selectedLesson["fileName"]!)
        self.total = words.count
        self.wordGenerator = WordGenerator(words: words, numberOfWordsToGenerate: words.count)
        self.currentWord = self.wordGenerator!.nextWord()!
        self.delegate = delegate
    }
    
    public func initialWord() -> Word?
    {
        if self.previousWord == nil
        {
            return self.currentWord
        }
        else
        {
            // So that sucessive calls to this method don't work.
            // TODO: Reset method
            return nil
        }
        
    }
    
    public func processGivenAnswer(givenAnswer : String)
    {
        var correctAnswer : String? = self.currentWord?.synonyms[0]
        correctAnswer = correctAnswer?.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        var safeGivenAnswer = givenAnswer.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        self.previousWord = self.currentWord // Store the old one
        if safeGivenAnswer == correctAnswer
        {
            if (self.previousWord != self.currentWord)
            {
                self.numberOfCorrectAnswers = self.numberOfCorrectAnswers + 1
            }
            
            self.count += 1
            self.currentWord = self.wordGenerator!.nextWord()?
            self.delegate.handleCorrectAnswerWithNextWord(self.currentWord)
        }
        else
        {
            self.delegate.handleFailedAttemptWithCorrectAnswer(correctAnswer!)
        }
    }

    
}
