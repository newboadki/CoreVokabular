//
//  TestExecutionDelegate.swift
//  CoreVokabular
//
//  Created by Borja Arias Drake on 04/06/2018.
//  Copyright © 2018 Borja Arias Drake. All rights reserved.
//

import Foundation

public protocol TestExecutionDelegate: class
{
    func handleCorrectAnswerWithNextWord(_ word : Word?)
    
    func handleFailedAttemptWithCorrectAnswer(_ correctAnswer : String)    
}
