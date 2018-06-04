//
//  Word.swift
//  Vokabular
//
//  Created by Borja Arias Drake on 15/08/2014.
//  Copyright (c) 2014 Borja Arias Drake. All rights reserved.
//

import Foundation

public class Word: NSObject
{
    public var name : NSString?
    public var synonyms : [String]
    
    public init(name: String, synonyms: [String])
    {
        self.name = name as NSString?
        self.synonyms = synonyms
    }
}
