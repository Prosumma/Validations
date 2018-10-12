//
//  _Optional.swift
//  Validations
//
//  Created by Gregory Higley on 10/11/18.
//  Copyright © 2018 Prosumma LLC. All rights reserved.
//

import Foundation

protocol _Optional {
    var isEmpty: Bool { get }
    var unwrapped: Any { get }
    var wrappedType: Any.Type { get }
}

extension Optional: _Optional {
    var isEmpty: Bool {
        return self == nil
    }
    var unwrapped: Any {
        return unsafelyUnwrapped
    }
    var wrappedType: Any.Type {
        return Wrapped.self
    }
}
