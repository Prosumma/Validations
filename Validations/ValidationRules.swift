//
//  ValidationRules.swift
//  Validations
//
//  Created by Gregory Higley on 10/11/18.
//  Copyright © 2018 Prosumma LLC. All rights reserved.
//

import Foundation

public extension ValidationRule {
    
    static func `return`(_ result: ValidationResult) -> ValidationRule {
        return ValidationRule { _ in result }
    }
    
    static let valid = ValidationRule.return(.valid)
    static let notApplicable = ValidationRule.return(.notApplicable)
    static let invalid = ValidationRule.return(.invalid)
    
    static func message(_ message: String, for rule: ValidationRule) -> ValidationRule {
        return ValidationRule { target in
            if !rule.validate(target).isValid {
                return ValidationResult(message)
            }
            return .valid
        }
    }
    
    static func not(_ rule: ValidationRule) -> ValidationRule {
        return ValidationRule { target in
            if rule.validate(target).isValid {
                return .invalid
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
        return .all(rules)
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
        return .any(rules)
    }
    
    static func `if`(_ condition: ValidationRule, then: ValidationRule, else: ValidationRule? = nil) -> ValidationRule {
        return ValidationRule { target in
            return condition.validate(target).isValid ? then.validate(target) : `else`?.validate(target) ?? .valid
        }
    }
    
    static func `if`<Target>(_ condition: @escaping (Target) -> Bool, then: ValidationRule, else: ValidationRule? = nil) -> ValidationRule {
        return ValidationRule { (target: Target) in
            return condition(target) ? then.validate(target) : `else`?.validate(target) ?? .valid
        }
    }
    
    static func ifMap<From, To>(_ transform: @escaping (From) -> To?, then: ValidationRule) -> ValidationRule {
        return ValidationRule { (target: From) in
            guard let transformed = transform(target) else {
                return .valid
            }
            return then.validate(transformed)
        }
    }
    
    static func `is`<Target>(_ type: Target.Type) -> ValidationRule {
        return ValidationRule { target in
            if target == nil || target! is Target { return .valid }
            return .invalid
        }
    }
    
    static let `nil` = ValidationRule { target in
        return target == nil ? .valid : .valueNotAllowed
    }
    
    static let notNil = ValidationRule.message(ValidationResult.valueRequiredMessage, for: .not(.nil))

    static func empty<C: Collection>(_ type: C.Type) -> ValidationRule {
        return ValidationRule { (target: C) in
            return target.isEmpty ? .valid : .valueNotAllowed
        }
    }
    
    static func notEmpty<C: Collection>(_ type: C.Type) -> ValidationRule {
        return .message(ValidationResult.valueRequiredMessage, for: .if(.is(C.self), then: .not(.empty(type))))
    }
    
    static let empty = ValidationRule.empty(String.self)
    static let notEmpty = ValidationRule.notEmpty(String.self)
    
    static let whitespace = ValidationRule { (target: String) in
        if target.isEmpty || !target.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "The value must consist solely of whitespace."
        }
        return .valid
    }
    
    static let notWhitespace = ValidationRule.message(ValidationResult.valueRequiredMessage, for: .if(.is(String.self), then: .not(.whitespace)))
    
    static func required<C: Collection>(_ type: C.Type) -> ValidationRule {
        return .message(ValidationResult.valueRequiredMessage, for: .all(.notNil, .notEmpty(C.self), .notWhitespace))
    }
    
    static let required = ValidationRule.required(String.self)
    
    static func compare(_ string: String, options: String.CompareOptions = []) -> ValidationRule {
        return ValidationRule { (target: String) in
            if target.range(of: string, options: options, range: nil, locale: nil) == nil {
                return .invalid
            }
            return .valid
        }
    }
    
    static func regex(_ regex: String, options: String.CompareOptions = []) -> ValidationRule {
        return compare(regex, options: options.union(.regularExpression))
    }
    
    static func range<Bound>(_ range: Range<Bound>) -> ValidationRule {
        return ValidationRule { (target: Bound) in
            return range.contains(target) ? .valid : .outOfRange
        }
    }
    
    static func convertible<To: RawRepresentable>(to: To.Type) -> ValidationRule {
        return ValidationRule { (target: To.RawValue) in
            return To(rawValue: target) == nil ? .invalid : .valid
        }
    }
    
    static func equals<E: Equatable>(_ other: E) -> ValidationRule {
        return ValidationRule { (target: E) in
            return target == other ? .valid : .invalid
        }
    }
    
    static func equalsAny<E: Equatable>(_ other: E) -> ValidationRule {
        return ValidationRule { target in
            guard let target = target as? E else {
                return .invalid
            }
            return target == other ? .valid : .invalid
        }
    }
    
    /*
    static func range<Bound>(_ range: ClosedRange<Bound>) -> ValidationRule {
        return ValidationRule { (target: Bound) in
            return range.contains(target) ? .valid : .outOfRange
        }
    }
    
    static func range<Bound>(_ range: CountableClosedRange<Bound>) -> ValidationRule {
        return ValidationRule { (target: Bound) in
            return range.contains(target) ? .valid : .outOfRange
        }
    }
    
    static func range<Bound>(_ range: PartialRangeFrom<Bound>) -> ValidationRule {
        return ValidationRule { (target: Bound) in
            return range.contains(target) ? .valid : .outOfRange
        }
    }
    
    static func range<Bound>(_ range: PartialRangeUpTo<Bound>) -> ValidationRule {
        return ValidationRule { (target: Bound) in
            return range.contains(target) ? .valid : .outOfRange
        }
    }
    
    static func range<Bound>(_ range: PartialRangeThrough<Bound>) -> ValidationRule {
        return ValidationRule { (target: Bound) in
            return range.contains(target) ? .valid : .outOfRange
        }
    }
    */
}
