//
//  Model.swift
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

protocol Model {

    var propertyNames: [String] { get }

    func value(at index: Int) -> Value?
}

func createModel(object: Any) -> Model {
    let mirror = Mirror(reflecting: object)

    if mirror.children.isEmpty, let obj = object as? NSObject {
        return NSObjectModel(object: obj)
    }

    return ObjectModel(object: object, mirror: mirror)
}

func createModel(dictionary: [AnyHashable: Any]) -> Model {
    return DictionaryModel(dictionary: dictionary)
}

func createModel(array: [Any]) -> Model {
    return ArrayModel(array: array)
}

class ObjectModel: Model {

    let object: Any

    let mirror: Mirror

    let propertyNames: [String]

    convenience fileprivate init(object: Any) {
        self.init(object: object, mirror: Mirror(reflecting: object))
    }

    fileprivate init(object: Any, mirror: Mirror) {
        self.object = object
        self.mirror = mirror
        propertyNames = mirror.propertyNames.sorted()
    }

    func value(at index: Int) -> Value? {
        return mirror.value(for: propertyNames[index])
    }
}

class NSObjectModel: Model {

    let propertyNames: [String]

    let object: NSObject

    fileprivate init(object: NSObject) {
        self.object = object
        propertyNames = Set(type(of: object).propertyNames.filter { !$0.starts(with: "_" )}).sorted()
    }

    func value(at index: Int) -> Value? {
        do {
            let key = propertyNames[index]
            let value = try ObjcExceptionHandler.result(of: { () -> Any? in
                object.value(forKey: key)
            })

            return Value(value: value)
        }
        catch {
            return Value(value: nil)
        }
    }
}

private extension NSObject {

    class var propertyNames: [String] {
        var count: UInt32 = 0
        guard let properties = class_copyPropertyList(self, &count) else {
            return []
        }

        let buffer = UnsafeBufferPointer(start: properties, count: Int(count))
        return buffer.compactMap { property -> String? in
            return String(utf8String: property_getName(property))
        }
    }
}

class ArrayModel: Model {

    let propertyNames: [String]

    let array: [Any]

    fileprivate init(array: [Any]) {
        self.array = array
        propertyNames = (0..<array.count).map {
            "[\($0)]"
        }
    }

    func value(at index: Int) -> Value? {
        return Value(value: array[index])
    }
}

class DictionaryModel: Model {

    let propertyNames: [String]

    let dictionary: [AnyHashable: Any]

    fileprivate init(dictionary: [AnyHashable: Any]) {
        self.dictionary = dictionary
        propertyNames = dictionary.keys.map { $0.description }
    }

    func value(at index: Int) -> Value? {
        return Value(value: dictionary[propertyNames[index]])
    }
}
