//
//  Result.swift
//  Validations
//
//  Created by Gregory Higley on 10/11/18.
//  Copyright © 2018 Prosumma LLC. All rights reserved.
//

import Foundation

public enum Result {
    case valid
    case invalid(String)
    
    public var isValid: Bool {
        if case .valid = self {
            return true
        }
        return false
    }
    
    public static let invalid = Result.invalid("The value is invalid.")
}


