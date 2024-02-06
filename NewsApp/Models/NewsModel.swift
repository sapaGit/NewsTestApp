//
//  NewsModel.swift
//  NewsApp
//

import Foundation
import Alamofire

// MARK: - LoginEncodable

struct NewsEncodable: Encodable {
    let country: String
}

// MARK: - LoginRequest

struct NewsRequest: RequestProtocol {
    let url = "news"
    let method: Alamofire.HTTPMethod = .get
    var params: [String: Any]?
}

// MARK: - NewsResponce
struct NewsModel: Decodable {
    let status: String
    let totalResults: Int
    let results: [Result]
    let nextPage: String
}

// MARK: - Result
struct Result: Decodable {
    let articleID: String
    let title: String
    let link: String
    let keywords: [String]?
    let creator: [String]?
    let description: String
    let pubDate: String
    let imageURL: String
    let sourceID: String
    let sourceURL: String
    let sourcePriority: Int
    let category: [String]

    enum CodingKeys: String, CodingKey {
        case articleID = "article_id"
        case title, link, keywords, creator
        case description, pubDate
        case imageURL = "image_url"
        case sourceID = "source_id"
        case sourceURL = "source_url"
        case sourcePriority = "source_priority"
        case category
    }
}