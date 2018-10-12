//
//  Rule.swift
//  Validations
//
//  Created by Gregory Higley on 10/11/18.
//  Copyright © 2018 Prosumma LLC. All rights reserved.
//

import Foundation

public struct Rule: ExpressibleByArrayLiteral {
    public typealias Validation<Arg> = (Arg) -> Result
    
    private let validation: Validation<Any?>
    
    public init(_ validation: @escaping Validation<Any?>) {
        self.validation = validation
    }
    
    public init<Target>(_ validation: @escaping Validation<Target>) {
        self.validation = { target in
            guard let target = target as? Target else {
                return .invalid
            }
            return validation(target)
        }
    }
    
    public init(arrayLiteral elements: Rule...) {
        self = .all(elements)
    }
    
    public func validate(_ value: Any?) -> Result {
        return validation(value)
    }
}

