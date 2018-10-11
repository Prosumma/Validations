//
//  ValidationRule.swift
//  Validations
//
//  Created by Gregory Higley on 10/11/18.
//  Copyright © 2018 Prosumma LLC. All rights reserved.
//

import Foundation

public struct ValidationRule {
    private var rule: (Any?) -> ValidationResult
    
    public init(_ rule: @escaping (Any?) -> ValidationResult) {
        self.rule = rule
    }
    
    /**
     Creates a typed validation rule.
     
     - warning: By default, a typed validation rule returns `.valid` if the
     target is `nil` or is not of type `Target`.
     */
    public init<Target>(_ rule: @escaping (Target) -> ValidationResult) {
        self.init { target in
            if let target = target as? Target {
                return rule(target)
            }
            return .valid
        }
    }
    
    public func validate(_ target: Any?) -> ValidationResult {
        return rule(target)
    }
}
