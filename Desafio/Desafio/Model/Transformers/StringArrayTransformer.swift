//
//  StringArrayTransformer.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 06-12-24.
//

import Foundation

@objc(StringArrayTransformer)
class StringArrayTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return NSArray.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let stringArray = value as? [String] else { return nil }
        return try? JSONSerialization.data(withJSONObject: stringArray)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        return try? JSONSerialization.jsonObject(with: data) as? [String]
    }
}
