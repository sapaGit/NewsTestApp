//
//  TypeDescribable.swift
//  NewsApp
//

import Foundation

/// The `TypeDescribable` protocol provides the capability to retrieve the type's name.
public protocol TypeDescribable {
    /// The static property `typeName` is used to return the name of the type.
    static var typeName: String { get }
}

public extension TypeDescribable {
    static var typeName: String {
        String(describing: self)
    }
}

