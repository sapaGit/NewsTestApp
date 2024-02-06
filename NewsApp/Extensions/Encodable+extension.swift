//
//  Encodable+extension.swift
//  NewsApp
//

import Foundation

extension Encodable {

    func toJSON() -> [String: Any]? {
        guard let data = toData(),
              let dictionary = try? JSONSerialization.jsonObject(
                with: data,
                options: .allowFragments
              ) as? [String: Any] else {

            return nil
        }

        return dictionary
    }

    func toData() -> Data? {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(self)

        return data
    }
}
