//
//  NewsModel.swift
//  NewsApp
//

import Foundation
import Alamofire

// MARK: - NewsEncodable

struct NewsEncodable: Encodable {
    let country: String
}

// MARK: - NewsRequest

struct NewsRequest: RequestProtocol {
    let url = "news"
    let method: Alamofire.HTTPMethod = .get
    var params: [String: Any]?
}

// MARK: - NewsResponce

struct NewsModel: Decodable {
    let status: String
    let totalResults: Int
    let results: [NewsData]
    let nextPage: String
}

// MARK: - Result

struct NewsData: Decodable {
    let articleID: String
    let title: String?
    let creator: [String]?
    let description: String?
    let pubDate: String?
    let imageURL: String?
    let sourceURL: String?

    enum CodingKeys: String, CodingKey {
        case articleID = "article_id"
        case title, creator
        case description, pubDate
        case imageURL = "image_url"
        case sourceURL = "source_url"
    }
}
