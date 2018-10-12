//
//  Validator.swift
//  Validations
//
//  Created by Gregory Higley on 10/12/18.
//  Copyright © 2018 Prosumma LLC. All rights reserved.
//

import Foundation

public struct Validator {
    private init() {}
    
    public static func validate<Target>(_ target: Target, withRules rules: RuleCollection<Target>) -> ResultCollection<Target> {
        var results: ResultCollection<Target> = [:]
        for (keyPath, rule) in rules {
            let value = target[keyPath: keyPath]
            let result: Result
            if let value = value as? _Optional {
                if value.isEmpty {
                    result = rule.validate(nil)
                } else {
                    result = rule.validate(value.unwrapped)
                }
            } else {
                result = rule.validate(target)
            }
            results[keyPath] = result
        }
        return results
    }
}
