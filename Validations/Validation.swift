//
//  Validation.swift
//  Validations
//
//  Created by Gregory Higley on 10/11/18.
//  Copyright © 2018 Prosumma LLC. All rights reserved.
//

import Foundation

public extension Rule {
    
    static let `nil` = test { $0 == nil }
    static let empty = test { (target: String) in target.isEmpty }
    
    static func containsCharacters(in characterSet: CharacterSet, options: String.CompareOptions = []) -> Rule {
        return test { (target: String) in target.rangeOfCharacter(from: characterSet, options: options, range: nil) != nil }
    }
    
    static let whitespace = !empty && test { (target: String) in target.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    static let emptyOrWhitespace = empty || whitespace
    static let containsWhitespace = containsCharacters(in: .whitespacesAndNewlines)
    static let emptyOrContainsWhitespace = empty || containsWhitespace
    
    static let required = message("A value is required.", for: !`nil` && (String.self &> !(empty || whitespace)))
    
    static func compare(_ string: String, options: String.CompareOptions = []) -> Rule {
        return test { (target: String) in target.range(of: string, options: options, range: nil, locale: nil) != nil }
    }
    
    static func regex(_ regex: String, options: String.CompareOptions = []) -> Rule {
        return compare(regex, options: options.union(.regularExpression))
    }
}



