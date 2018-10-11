//
//  _Optional.swift
//  Validations
//
//  Created by Gregory Higley on 10/11/18.
//  Copyright © 2018 Prosumma LLC. All rights reserved.
//

import Foundation

protocol _Optional {
    var _hasValue: Bool { get }
    var _unwrapped: Any { get }
}

extension Optional: _Optional {
    var _hasValue: Bool {
        return self != nil
    }
    var _unwrapped: Any {
        return unsafelyUnwrapped
    }
}
