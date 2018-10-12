//
//  Server.swift
//  Validations
//
//  Created by Gregory Higley on 10/12/18.
//  Copyright © 2018 Prosumma LLC. All rights reserved.
//

import Foundation
import Validations

struct Server: Validatable {
    let username: String
    let password: String
    
    let validationRules: [PartialKeyPath<Server> : Rule] = [
        \Server.username: [
            .required,
            !.containsWhitespace
        ],
        \Server.password: [
            .required,
            .test{ (password: String) in (8...16).contains(password.count) }
        ]
    ]
}
