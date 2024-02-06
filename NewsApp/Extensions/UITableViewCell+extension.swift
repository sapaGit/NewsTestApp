//
//  UITableViewCell+extension.swift
//  NewsApp
//

import UIKit

extension UITableViewCell: TypeDescribable {
}

public extension UITableViewCell {
    /// A static property `reuseIdentifier` that returns the type's name as the reuseIdentifier.
    static var reuseIdentifier: String {
        typeName
    }
}
