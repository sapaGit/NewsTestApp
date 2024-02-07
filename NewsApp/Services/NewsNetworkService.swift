//
//  NewsNetworkService.swift
//  NewsApp
//

import Foundation
import Alamofire

protocol NewsServiceProtocol {
    /// Get news .
    func getNews(completion: @escaping (AFResult<NewsModel>) -> Void)
    /// Get news from next page
    func getNextNews(pageNumber: String, completion: @escaping (AFResult<NewsModel>) -> Void)
}

final class NewsService {

    // MARK: - Dependencies

    private let netwokManager: NetworkManagerProtocol

    // MARK: - init

    init(netwokManager: NetworkManagerProtocol) {
        self.netwokManager = netwokManager
    }
}

// MARK: - NewsServiceProtocol

extension NewsService: NewsServiceProtocol {
    /// Get news .
    func getNews(completion: @escaping (AFResult<NewsModel>) -> Void) {

        let parameters = [
            "apiKey": String.Services.apiKey,
            "country": "us",
            "category": "top"
        ]
        let request: RequestProtocol = NewsRequest(params: parameters)

        netwokManager.makeRequest(request: request, error: .news, completion: completion)
    }
    /// Get news from next page
    func getNextNews(pageNumber: String, completion: @escaping (AFResult<NewsModel>) -> Void) {

        let parameters = [
            "apiKey" : String.Services.apiKey,
            "country" : "us",
            "category": "top",
            "page" : pageNumber
        ]
        let request: RequestProtocol = NewsRequest(params: parameters)

        netwokManager.makeRequest(request: request, error: .news, completion: completion)
    }
}
