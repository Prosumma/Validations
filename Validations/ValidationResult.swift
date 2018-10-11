//
//  ValidationResult.swift
//  Validations
//
//  Created by Gregory Higley on 10/11/18.
//  Copyright © 2018 Prosumma LLC. All rights reserved.
//

import Foundation

public struct ValidationResult {
    public let isValid: Bool
    public let message: String
    
    public init(_ message: String, valid: Bool = false) {
        self.isValid = valid
        self.message = message
    }
    
    public static let valid = ValidationResult("The value is valid.", valid: true)
}
