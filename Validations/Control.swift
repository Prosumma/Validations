//
//  Control.swift
//  Validations
//
//  Created by Gregory Higley on 10/11/18.
//  Copyright © 2018 Prosumma LLC. All rights reserved.
//

import Foundation

infix operator &>: TernaryPrecedence
infix operator *>: TernaryPrecedence

public extension Rule {
    
    static let valid = Rule.return(.valid)
    static let invalid = Rule.return(.invalid)
    
    static func message(_ message: String, for rule: Rule) -> Rule {
        return Rule { target in
            let result = rule.validate(target)
            return result.isValid ? result : .invalid(message)
        }
    }
    
    static func test(_ predicate: @escaping (Any?) -> Bool) -> Rule {
        return Rule { predicate($0) ? .valid : .invalid }
    }
    
    static func test<Target>(_ predicate: @escaping (Target) -> Bool) -> Rule {
        return Rule { (target: Target) in predicate(target) ? .valid : .invalid }
    }
    
    static func `return`(_ result: Result) -> Rule {
        return Rule { _ in result }
    }
    
    static func `not`(_ rule: Rule) -> Rule {
        return Rule { target in
            let result = rule.validate(target)
            return result.isValid ? .invalid : .valid
        }
    }
    
    static func `if`(_ condition: Rule, then: Rule, else: Rule = .invalid) -> Rule {
        return Rule { target in
            return condition.validate(target).isValid ? then.validate(target) : `else`.validate(target)
        }
    }
    
    static func map<Target, Transformed>(_ transform: @escaping (Target) -> Transformed?, then: Rule) -> Rule {
        return Rule { (target: Target) in
            guard let transformed = transform(target) else {
                return .invalid
            }
            return then.validate(transformed)
        }
    }
    
    static func when(_ condition: Rule, then: Rule) -> Rule {
        return `if`(condition, then: then, else: .valid)
    }
    
    static func all<Rules: Sequence>(_ rules: Rules) -> Rule where Rules.Element == Rule {
        return Rule { target in
            for rule in rules {
                if case let result = rule.validate(target), !result.isValid {
                    return result
                }
            }
            return .valid
        }
    }
    
    static func all(_ rules: Rule...) -> Rule {
        return all(rules)
    }
    
    static func any<Rules: Sequence>(_ rules: Rules) -> Rule where Rules.Element == Rule {
        return Rule { target in
            var result: Result = .invalid
            for rule in rules {
                result = rule.validate(rule)
                if result.isValid { break }
            }
            return result
        }
    }
    
    static func any(_ rules: Rule...) -> Rule {
        return any(rules)
    }
    
    static func `is`<Target>(_: Target.Type) -> Rule {
        return Rule { (target: Target) in .valid }
    }
    
    public static prefix func!(rule: Rule) -> Rule {
        return not(rule)
    }
    
    public static func &&(lhs: Rule, rhs: Rule) -> Rule {
        return all(lhs, rhs)
    }
    
    public static func ||(lhs: Rule, rhs: Rule) -> Rule {
        return any(lhs, rhs)
    }
    
    public static func &>(lhs: Rule, rhs: Rule) -> Rule {
        return when(lhs, then: rhs)
    }
    
    public static func &><T>(_: T.Type, rhs: Rule) -> Rule {
        return when(.is(T.self), then: rhs)
    }
    
    public static func *><Target, Transformed>(lhs: @escaping (Target) -> Transformed?, rhs: Rule) -> Rule {
        return map(lhs, then: rhs)
    }
    
}

