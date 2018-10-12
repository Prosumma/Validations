//
//  ValidationTests.swift
//  Validations
//
//  Created by Gregory Higley on 10/12/18.
//  Copyright © 2018 Prosumma LLC. All rights reserved.
//

import XCTest
import Validations

class ValidationTests: XCTestCase {

    func testValidation() {
        let rule: Rule = [
            .required,
            String.self || Int.self,
            String.self &> Map.stringToInt *> .range(3...),
            Int.self &> .range(3...)
        ]
        
        let result = rule.validate(22)
        if case .invalid(let message) = result {
            XCTFail(message)
        }
    }

}
