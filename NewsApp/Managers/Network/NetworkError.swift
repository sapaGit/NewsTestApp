//
//  NetworkError.swift
//  NewsApp
//

import Foundation

final class NetworkError: NSObject, Error {

    // MARK: - Properties

    var type: TypeError
    var message: String?

    // MARK: - init

    init(_ type: TypeError, message: String? = nil) {
        self.type = type
        self.message = message
    }
}

// TODO: add SwiftGen

enum TypeError: String, Error {
    case notConnectedToInternet = "No Internet connection"
    case timeLimitExceeded = "Request time limit exceeded"
    case invalidURL = "Incorrect URL"
    case news = "Failed to get news"
}

