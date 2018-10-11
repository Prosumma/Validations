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
        let ageRange: ValidationRule = .message("Only ages 7 and 20!", for: .any(.equals(7), .equals(20)))
        return [
            \User.name: .required,
            \User.gender: .convertible(to: Gender.self),
            \User.age: .all (
                .required,
                .any(.is(String.self), .is(Int.self)),
                .ifMap(Convert.stringToInt, then: ageRange),
                ageRange
            )
        ]
    }
}
