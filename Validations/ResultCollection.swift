//
//  ResultCollection.swift
//  Validations
//
//  Created by Gregory Higley on 10/11/18.
//  Copyright © 2018 Prosumma LLC. All rights reserved.
//

import Foundation

public struct ResultCollection<Target>: Collection, Error, ExpressibleByDictionaryLiteral {
    
    public enum Key: Hashable {
        case type
        case keyPath(PartialKeyPath<Target>)
        
        public static func ==(lhs: Key, rhs: Key) -> Bool {
            switch lhs {
            case .type: if case .type = rhs { return true }
            case .keyPath(let keyPath): if case .keyPath(let otherKeyPath) = rhs, keyPath == otherKeyPath { return true }
            }
            return false
        }
        
        public func hash(into hasher: inout Hasher) {
            switch self {
            case .type: hasher.combine(String(reflecting: Target.self))
            case .keyPath(let keyPath): hasher.combine(keyPath)
            }
        }
    }
    
    public typealias Container = Dictionary<Key, Result>
    public typealias Index = Container.Index
    public typealias Element = Container.Element
    
    private var container: Container = [:]
    
    public init() {}
    
    public init(dictionaryLiteral elements: (Key, Result)...) {
        for (key, result) in elements {
            container[key] = result
        }
    }
    
    public var startIndex: Index {
        return container.startIndex
    }
    
    public var endIndex: Index {
        return container.endIndex
    }
    
    public func index(after i: Index) -> Index {
        return container.index(after: i)
    }
    
    public subscript(position: Index) -> Element {
        return container[position]
    }
    
    public subscript(key: Key) -> Result {
        get { return container[key] ?? .valid }
        set { container[key] = newValue }
    }
    
    public subscript(keyPath: PartialKeyPath<Target>) -> Result {
        get {
            let key = Key.keyPath(keyPath)
            return self[key]
        }
        set {
            let key = Key.keyPath(keyPath)
            self[key] = newValue
        }
    }
}
