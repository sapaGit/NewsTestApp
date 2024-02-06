//
//  String+extension.swift
//  NewsApp
//

import Foundation
extension String {
    func toDateFormattedString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "dd MMMM yyyy"
            return dateFormatter.string(from: date)
        }

        return nil
    }
}
