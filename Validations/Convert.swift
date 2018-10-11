//
//  Convert.swift
//  Validations
//
//  Created by Gregory Higley on 10/11/18.
//  Copyright © 2018 Prosumma LLC. All rights reserved.
//

import Foundation

public struct Convert {
    private init() {}
    
    public static func stringToInt(_ string: String) -> Int? {
        return Int(string)
    }
    
    public static func to<Raw: RawRepresentable>(_ type: Raw.Type) -> (Raw.RawValue) -> Raw? {
        return { Raw(rawValue: $0) }
    }
}
