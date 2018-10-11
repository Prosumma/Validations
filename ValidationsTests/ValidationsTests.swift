//
//  ValidationsTests.swift
//  ValidationsTests
//
//  Created by Gregory Higley on 10/11/18.
//  Copyright © 2018 Prosumma LLC. All rights reserved.
//

import XCTest
@testable import Validations

class ValidationsTests: XCTestCase {

    func testValidationRequired() {
        let rule = ValidationRule.required
        let target = ""
        XCTAssertFalse(rule.validate(target).isValid)
    }
    
    func testValidationExpectType() {
        let rule = ValidationRule.type(Int.self)
        XCTAssertTrue(rule.validate(5).isValid)
        XCTAssertFalse(rule.validate("5").isValid)
    }
    
    func testValidationComplex1() {
        let rule = ValidationRule
            .all (
                .required,
                .any(.type(String.self), .type(Int.self)),
                .regex("^\\d+$"),
                .range(0..<100)
            )
        XCTAssertTrue(rule.validate("33").isValid)
        XCTAssertFalse(rule.validate(nil).isValid)
        XCTAssertTrue(rule.validate(33).isValid)
        XCTAssertFalse(rule.validate(33.7).isValid)
    }
    
    func testValidateUser() {
        var user = User()
        user.name = "Greg"
        user.age = 49
        let validations = user.validate()
        XCTAssertTrue(validations[\User.name].isValid)
        XCTAssertFalse(validations[\User.age].isValid)
        XCTAssertTrue(validations[\User.sheep].isValid)
    }

}
