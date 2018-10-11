//
//  ValidationResultCollection.swift
//  Validations
//
//  Created by Gregory Higley on 10/11/18.
//  Copyright © 2018 Prosumma LLC. All rights reserved.
//

import Foundation

public struct ValidationResultCollection<Target>: Collection, ExpressibleByDictionaryLiteral {

    public init(dictionaryLiteral elements: (PartialKeyPath<Target>, ValidationResult)...) {
        for (key, result) in elements {
            storage[.keyPath(key)] = result
        }
    }
    
    public typealias Storage = Dictionary<ValidationTarget<Target>, ValidationResult>
    public typealias Element = Storage.Element
    public typealias Index = Storage.Index
    
    private var storage: Storage = [:]
    
    public func index(after i: Index) -> Index {
        return storage.index(after: i)
    }
    
    public subscript(position: Storage.Index) -> Element {
        return storage[position]
    }
    
    public var typeResult: ValidationResult {
        get { return storage[.type] ?? .valid }
        set { storage[.type] = newValue }
    }
    
    public subscript(key: PartialKeyPath<Target>) -> ValidationResult {
        get { return storage[.keyPath(key)] ?? .valid }
        set { storage[.keyPath(key)] = newValue }
    }
    
    public var startIndex: Storage.Index {
        return storage.startIndex
    }
    
    public var endIndex: Storage.Index {
        return storage.endIndex
    }
}
