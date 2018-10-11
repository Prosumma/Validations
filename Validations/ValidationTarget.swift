//
//  ValidationTarget.swift
//  Validations
//
//  Created by Gregory Higley on 10/11/18.
//  Copyright © 2018 Prosumma LLC. All rights reserved.
//

import Foundation

public enum ValidationTarget<Target>: Hashable {
    case type
    case keyPath(PartialKeyPath<Target>)
    
    public static func ==<Target>(lhs: ValidationTarget<Target>, rhs: ValidationTarget<Target>) -> Bool {
        switch lhs {
        case .type: if case .type = rhs { return true }
        case .keyPath(let keyPath): if case .keyPath(let otherKeyPath) = rhs, keyPath == otherKeyPath { return true }
        }
        return false
    }
}
