//
//  Map.swift
//  Validations
//
//  Created by Gregory Higley on 10/11/18.
//  Copyright © 2018 Prosumma LLC. All rights reserved.
//

import Foundation

public struct Map {
    private init() {}
    
    public func trimString(_ string: String) -> String? {
        return string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    public static let stringToInt: (String) -> Int? = Int.init
}
