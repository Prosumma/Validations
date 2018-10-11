//
//  User.swift
//  Validations
//
//  Created by Gregory Higley on 10/11/18.
//  Copyright © 2018 Prosumma LLC. All rights reserved.
//

import Foundation
@testable import Validations

enum Gender: String {
    case m, f
}

struct User: Validatable {
    var name: String?
    var gender: Gender?
    var age: Int = 0
    var sheep: Double?

    var validationRules: [PartialKeyPath<User>: ValidationRule] {
        let ageRange: ValidationRule = .range(18..<25)
        return [
            \User.name: .required,
            \User.gender: .convertible(to: Gender.self),
            \User.age: .all (
                .required,
                .any(.type(String.self), .type(Int.self)),
                .ifMap(Convert.stringToInt, then: ageRange),
                ageRange
            )
        ]
    }
}
