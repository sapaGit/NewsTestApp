//
//  StorageManager.swift
//  NewsApp
//


import Foundation

class UserDefaultsManager {

    private static let userDefaults = UserDefaults.standard


    static func save(value: String, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }

    static func removeValue(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }

    static func isAddedToFavorites(forKey key: String) -> Bool {
        userDefaults.string(forKey: key) != nil
    }
}
