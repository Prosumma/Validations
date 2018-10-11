//
//  Validatable.swift
//  Validations
//
//  Created by Gregory Higley on 10/11/18.
//  Copyright © 2018 Prosumma LLC. All rights reserved.
//

import Foundation

public protocol Validatable {
    var validationRules: [PartialKeyPath<Self>: ValidationRule] { get }
    func validate() -> ValidationResultCollection<Self>
}

public extension Validatable {
    func validate() -> ValidationResultCollection<Self> {
        return Validator.validateRules(self)
    }
}
