//
//  NewsNetworkService.swift
//  NewsApp
//

import Foundation
import Alamofire

protocol AuthServiceProtocol {
    /// Get news .
    func getNews(completion: @escaping (AFResult<NewsModel>) -> Void)
}

final class AuthService {

    // MARK: - Dependencies

    private let netwokManager: NetworkManagerProtocol

    // MARK: - init

    init(netwokManager: NetworkManagerProtocol) {
        self.netwokManager = netwokManager
    }
}

// MARK: - AuthServiceProtocol

extension AuthService: AuthServiceProtocol {
    /// Get news .
    func getNews(completion: @escaping (AFResult<NewsModel>) -> Void) {

        let parameters = [
            "apiKey": String.Services.apiKey,
            "country": "us"
        ]
        let request: RequestProtocol = NewsRequest(params: parameters)

        netwokManager.makeRequest(request: request, error: .news, completion: completion)
    }
    /// Get news from next page
    func getNextNews(pageNumber: Int, completion: @escaping (AFResult<NewsModel>) -> Void) {

        let parameters = [
            "apiKey" : String.Services.apiKey,
            "country" : "us",
            "page" : "\(pageNumber)"
        ]
        let request: RequestProtocol = NewsRequest(params: parameters)

        netwokManager.makeRequest(request: request, error: .news, completion: completion)
    }
}
