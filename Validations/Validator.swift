//
//  Validator.swift
//  Validations
//
//  Created by Gregory Higley on 10/11/18.
//  Copyright © 2018 Prosumma LLC. All rights reserved.
//

import Foundation

public struct Validator {
    private init() {}
    
    public static func value<Target>(of keyPath: PartialKeyPath<Target>, in target: Target) -> Any? {
        let value = target[keyPath: keyPath]
        if let value = value as? _Optional {
            if !value._hasValue {
                return nil
            } else {
                return value._unwrapped
            }
        } else {
            return value
        }
    }
    
    public static func validateRules<Target: Validatable>(_ target: Target) -> ValidationResultCollection<Target> {
        var result: ValidationResultCollection<Target> = [:]
        for (keyPath, rule) in target.validationRules {
            result[keyPath] = rule.validate(value(of: keyPath, in: target))
        }
        return result
    }
}
