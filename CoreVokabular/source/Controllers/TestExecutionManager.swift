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
    func handleCorrectAnswerWithNextWord(_ word : Word?)
    func handleFailedAttemptWithCorrectAnswer(_ correctAnswer : String)
    
}

public class TestExecutionManager
{
    // Components
    var wordGenerator : WordGenerator?
    
    // State
    public var currentWord : Word?
    public var numberOfCorrectAnswers : Int = 0
    public var count : Int = 0
    public var total : Int = 0
    public var selectedLesson : Dictionary<String, String>
    
    var previousWord : Word?
    var delegate : TestExecutionDelegate
    
    
    public init(delegate : TestExecutionDelegate, selectedLesson :Dictionary<String, String> )
    {
        let parser = WordParser()
        self.selectedLesson = selectedLesson
        let words = parser.parseWordsFromFileInfo(self.selectedLesson)
        self.total = words.count
        self.wordGenerator = WordGenerator(words: words, numberOfWordsToGenerate: words.count)
        self.currentWord = self.wordGenerator!.nextWord()
        self.delegate = delegate
    }
    
    public func initialWord() -> Word?
    {
        if self.previousWord == nil
        {
            self.count += 1
            return self.currentWord
        }
        else
        {
            // So that sucessive calls to this method don't work.
            // TODO: Reset method
            return nil
        }
        
    }
    
    public func processGivenAnswer(_ givenAnswer : String)
    {
        var correctAnswer : String? = self.currentWord?.synonyms[0]
        correctAnswer = correctAnswer?.lowercased().trimmingCharacters(in: CharacterSet.whitespaces)
        let safeGivenAnswer :String? = givenAnswer.lowercased().trimmingCharacters(in: CharacterSet.whitespaces)
        
        
        if safeGivenAnswer == correctAnswer
        {
            if (self.previousWord != self.currentWord)
            {
                self.numberOfCorrectAnswers = self.numberOfCorrectAnswers + 1
            }
            self.previousWord = self.currentWord // Store the old one
            if self.count < self.total
            {
                self.count += 1
            }
            
            self.currentWord = self.wordGenerator!.nextWord()
            self.delegate.handleCorrectAnswerWithNextWord(self.currentWord)
        }
        else
        {
            self.previousWord = self.currentWord // Store the old one
            self.delegate.handleFailedAttemptWithCorrectAnswer(correctAnswer!)
        }
    }

    
}
