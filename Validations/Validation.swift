//
//  Validation.swift
//  Validations
//
//  Created by Gregory Higley on 10/11/18.
//  Copyright © 2018 Prosumma LLC. All rights reserved.
//

import Foundation

public extension Rule {
    
    private static let ipv4Segment = "(25[0-5]|2[0-4]\\d|1?(\\d){0,2})"
    private static let ipv4Address = "((\(ipv4Segment)\\.){3}\(ipv4Segment))"
    private static let ipv4Pattern = "^\(ipv4Address)$"
    
    private static let ipv6Segment = "[\\da-fA-F]{1,4}"
    private static let ipv6Address = "((\(ipv6Segment):){7}\(ipv6Segment)|(\(ipv6Segment):){1,7}:|(\(ipv6Segment):){1,6}:\(ipv6Segment)|(\(ipv6Segment):){1,5}(:\(ipv6Segment)){1,2}|(\(ipv6Segment):){1,4}(:\(ipv6Segment)){1,3}|(\(ipv6Segment):){1,3}(:\(ipv6Segment)){1,4}|(\(ipv6Segment):){1,1}(:\(ipv6Segment)){1,5}|:(:\(ipv6Segment)){1,7}|(\(ipv6Segment):){1,5}(:\(ipv6Segment)){1,2}|::([fF]{4}(:0{1,4})?:)?\(ipv4Address)|(\(ipv6Segment):){1,4}:\(ipv4Address))"
    private static let ipv6Pattern = "^\(ipv6Address)$"
    
    static let `nil` = test { $0 == nil }
    static let empty = test { (target: String) in target.isEmpty }
    
    static func containsCharacters(in characterSet: CharacterSet, options: String.CompareOptions = []) -> Rule {
        return test{ (target: String) in target.rangeOfCharacter(from: characterSet, options: options, range: nil) != nil }
    }
    
    static let whitespace = !empty && test { (target: String) in target.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    static let emptyOrWhitespace = empty || whitespace
    static let containsWhitespace = containsCharacters(in: .whitespacesAndNewlines)
    static let emptyOrContainsWhitespace = empty || containsWhitespace
    
    static let required = message("A value is required.", for: !`nil` && (String.self &> !(empty || whitespace)))
    
    static func compare(_ string: String, options: String.CompareOptions = []) -> Rule {
        return test{ (target: String) in target.range(of: string, options: options, range: nil, locale: nil) != nil }
    }
    
    static func regex(_ regex: String, options: String.CompareOptions = []) -> Rule {
        return compare(regex, options: options.union(.regularExpression))
    }
    
    static func range<R: RangeExpression>(_ range: R) -> Rule {
        return test{ (target: R.Bound) in range.contains(target) }
    }
    
    static let ipv4 = regex(Rule.ipv4Pattern)
    static let ipv6 = regex(Rule.ipv6Pattern)
    static let ip = ipv4 || ipv6

    static func count<C: Collection>(of _: C.Type, equalTo count: Int) -> Rule {
        return test{ (target: C) in target.count == count }
    }

    static func count<C: Collection, R: RangeExpression>(of _: C.Type, in range: R) -> Rule where R.Bound == Int {
        return test{ (target: C) in range.contains(target.count) }
    }
    
    static func length(equalTo length: Int) -> Rule {
        return count(of: String.self, equalTo: length)
    }
    
    static func length<R: RangeExpression>(in range: R) -> Rule where R.Bound == Int {
        return count(of: String.self, in: range)
    }

}

