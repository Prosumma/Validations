//
//  ValidationResult.swift
//  Validations
//
//  Created by Gregory Higley on 10/11/18.
//  Copyright © 2018 Prosumma LLC. All rights reserved.
//

import Foundation

public struct ValidationResult: ExpressibleByStringLiteral {
    public let isValid: Bool
    public let message: String
    
    public init(_ message: String, valid: Bool = false) {
        self.isValid = valid
        self.message = message
    }
    
    public init(stringLiteral value: String) {
        self.init(value, valid: false)
    }
    
    public static let valueRequiredMessage = "A value is required."
    public static let valueNotAllowedMessage = "A value is not allowed."
    public static let invalidMessage = "The value is invalid."
    public static let outOfRangeMessage = "The value is outside of the permitted range."
    
    public static let valid = ValidationResult("The value is valid.", valid: true)
    public static let valueRequired = ValidationResult(ValidationResult.valueRequiredMessage)
    public static let valueNotAllowed = ValidationResult(ValidationResult.valueRequiredMessage)
    public static let invalid = ValidationResult(ValidationResult.invalidMessage)
    public static let outOfRange = ValidationResult(ValidationResult.outOfRangeMessage)
}
