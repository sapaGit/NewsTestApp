//
//  RequestProtocol.swift
//  NewsApp
//

import Foundation
import Alamofire

// MARK: - RequestProtocol

protocol RequestProtocol {

    var url: String { get }
    var method: HTTPMethod { get }
    var body: Data? { get }
    var params: [String: Any]? { get }
    var headers: HTTPHeaders? { get }
    var encoding: ParameterEncoding? { get }
    var baseURL: String { get }
}

extension RequestProtocol {
    var body: Data? { nil }
    var params: [String: Any]? { nil }
    var headers: HTTPHeaders? { nil }
    var encoding: ParameterEncoding? { nil }
    var baseURL: String { "https://newsdata.io/api/1/" }

}
