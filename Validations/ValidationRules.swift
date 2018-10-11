//
//  ValidationRules.swift
//  Validations
//
//  Created by Gregory Higley on 10/11/18.
//  Copyright © 2018 Prosumma LLC. All rights reserved.
//

import Foundation

public extension ValidationRule {
    
    static let valid = ValidationRule { _ in return .valid }
    
    static func notNil(message: String = "A value is required.") -> ValidationRule {
        return ValidationRule { target in
            if target == nil {
                return ValidationResult(message)
            }
            return .valid
        }
    }
    
    static let notNil = ValidationRule.notNil()
    
    static func required(message: String = "A value is required.") -> ValidationRule {
        return ValidationRule { target in
            if target == nil {
                return ValidationResult(message)
            }
            if let string = target! as? String, string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return ValidationResult(message)
            }
            return .valid
        }
    }
    
    static let required = ValidationRule.required()
    
    static func notWhitespace(message: String = "A value is required.") -> ValidationRule {
        return ValidationRule { (target: String) in
            if target.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return ValidationResult(message)
            }
            return .valid
        }
    }
    
    static let notWhitespace = ValidationRule.notWhitespace()
    
    static func notEmpty<C: Collection>(type: C.Type, message: String = "A value is required.") -> ValidationRule {
        return ValidationRule { (target: C) in
            if target.isEmpty {
                return ValidationResult(message)
            }
            return .valid
        }
    }
    
    static let notEmpty = ValidationRule.notEmpty(type: String.self)
 
    static func type<T>(_ type: T.Type, message: String? = nil) -> ValidationRule {
        return ValidationRule { target in
            if target is T? {
                return .valid
            }
            let expectedTypeName = String(reflecting: type)
            return ValidationResult("A value of type \"\(expectedTypeName)\" was expected.")
        }
    }
    
    static func compare(to string: String, options: String.CompareOptions = [], message: String = "The value is invalid.") -> ValidationRule {
        return ValidationRule { (target: String) in
            if target.range(of: string, options: options, range: nil, locale: nil) == nil {
                return ValidationResult(message)
            }
            return .valid
        }
    }
    
    static func regex(_ regex: String, options: String.CompareOptions = [], message: String = "The value is invalid.") -> ValidationRule {
        return compare(to: regex, options: options.union(.regularExpression), message: message)
    }
    
    static func convertible<Raw: RawRepresentable>(to type: Raw.Type, message: String = "The value could not be converted to the target type.") -> ValidationRule {
        return ValidationRule { (target: Raw.RawValue) in
            if Raw(rawValue: target) == nil {
                return ValidationResult(message)
            }
            return .valid
        }
    }
    
    static func convertible<From, To>(by convert: @escaping (From) -> To?, message: String = "The value could not be converted to the target type.") -> ValidationRule {
        return ValidationRule { (target: From) in
            if convert(target) == nil {
                return ValidationResult(message)
            }
            return .valid
        }
    }
    
    static func range<Bound>(_ range: PartialRangeFrom<Bound>, message: String = "The value was not in the accepted range.") -> ValidationRule {
        return ValidationRule { (target: Bound) in
            if !range.contains(target) {
                return ValidationResult(message)
            }
            return .valid
        }
    }
    
    static func range<Bound>(_ range: Range<Bound>, message: String = "The value was not in the accepted range.") -> ValidationRule {
        return ValidationRule { (target: Bound) in
            if !range.contains(target) {
                return ValidationResult(message)
            }
            return .valid
        }
    }
    
    static func range<Bound>(_ range: PartialRangeUpTo<Bound>, message: String = "The value was not in the accepted range.") -> ValidationRule {
        return ValidationRule { (target: Bound) in
            if !range.contains(target) {
                return ValidationResult(message)
            }
            return .valid
        }
    }
    
    static func range<Bound>(_ range: PartialRangeThrough<Bound>, message: String = "The value was not in the accepted range.") -> ValidationRule {
        return ValidationRule { (target: Bound) in
            if !range.contains(target) {
                return ValidationResult(message)
            }
            return .valid
        }
    }
    
    static func all<Rules: Sequence>(_ rules: Rules) -> ValidationRule where Rules.Element == ValidationRule {
        return ValidationRule { target in
            for rule in rules {
                if case let result = rule.validate(target), !result.isValid {
                    return result
                }
            }
            return .valid
        }
    }
    
    static func all(_ rules: ValidationRule...) -> ValidationRule {
        return all(rules)
    }
    
    static func any<Rules: Sequence>(_ rules: Rules) -> ValidationRule where Rules.Element == ValidationRule {
        return ValidationRule { target in
            var result: ValidationResult = .valid
            for rule in rules {
                result = rule.validate(target)
                if result.isValid { break }
            }
            return result
        }
    }
    
    static func any(_ rules: ValidationRule...) -> ValidationRule {
        return any(rules)
    }
    
    static func `if`(_ condition: ValidationRule, then: ValidationRule) -> ValidationRule {
        return ValidationRule { target in
            if condition.validate(target).isValid {
                return then.validate(target)
            } else {
                return .valid
            }
        }
    }
    
    static func `if`(_ condition: @escaping (Any) -> Bool, then: ValidationRule) -> ValidationRule {
        return ValidationRule { target in
            guard let target = target else {
                return .valid
            }
            if condition(target) {
                return then.validate(target)
            }
            return .valid
        }
    }
    
    static func not(_ rule: ValidationRule, message: String) -> ValidationRule {
        return ValidationRule { target in
            if !rule.validate(target).isValid {
                return .valid
            } else {
                return ValidationResult(message)
            }
        }
    }
    
    static func map<From, To>(_ transform: @escaping (From) -> To?, then: ValidationRule) -> ValidationRule {
        return ValidationRule { (target: From) in
            guard let transformed = transform(target) else {
                return .valid
            }
            return then.validate(transformed)
        }
    }
    
}
