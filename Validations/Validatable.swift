//
//  Validatable.swift
//  Validations
//
//  Created by Gregory Higley on 10/12/18.
//  Copyright © 2018 Prosumma LLC. All rights reserved.
//

import Foundation

public typealias RuleCollection<Target> = [PartialKeyPath<Target>: Rule]

public protocol Validatable {
    var validationRules: RuleCollection<Self> { get }
    func validate() -> ResultCollection<Self>
}

public extension Validatable {
    func validate() -> ResultCollection<Self> {
        return Validator.validate(self, withRules: validationRules)
    }
}
