//
//  Value.swift
//  RIObjectInspector
//
//  Copyright (c) 2020 Rocket Insights, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//

import Foundation

enum Value: CustomStringConvertible {

    case scalar(String)

    case array([Any])

    case dictionary([AnyHashable: Any])

    case object(Any)

    init?(value: Any?) {
        guard let value = value else {
            return nil
        }

        if let array = value as? [Any] {
            self = .array(array)
        }
        else if let dict = value as? [AnyHashable: Any] {
            self = .dictionary(dict)
        }
        else if let scalar = Value.descriptionIfScalar(of: value) {
            self = .scalar(scalar)
        }
        else {
            self = .object(value)
        }
    }

    private static func descriptionIfScalar(of obj: Any) -> String? {
        if let i = obj as? Int {
            return i.description
        }
        else if let f = obj as? Float {
            return f.description
        }
        else if let d = obj as? Double {
            return d.description
        }
        else if let b = obj as? Bool {
            return b.description
        }
        else if let s = obj as? String {
            return s
        }
        else {
            return nil
        }
    }

    var description: String {
        switch self {
        case .array(let array):
            let noun = array.count == 1 ? "item" : "items"
            return "Array with \(array.count) \(noun)"

        case .dictionary(let dict):
            let noun = dict.count == 1 ? "item": "items"
            return "Dictionary with \(dict.count) \(noun)"

        case .scalar(let value):
            return value.description

        case .object(let object):
            return String(describing: type(of: object))
        }
    }

    var isLeaf: Bool {
        switch self {
        case .scalar:
            return true

        case .array, .dictionary, .object:
            return false
        }
    }
}
