//
//  NetworkManager.swift
//  NewsApp
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol {
    /// Makes a network request based on the provided parameters.
    func makeRequest<T: Decodable>(
        request: RequestProtocol,
        error: TypeError,
        completion: @escaping (AFResult<T>) -> Void
    )
}

final class NetworkManager: NetworkManagerProtocol {

    static let shared = NetworkManager()

    private init() {}

    func makeRequest<T: Decodable>(
        request: RequestProtocol,
        error: TypeError,
        completion: @escaping (AFResult<T>) -> Void
    ) {
        guard let url = URL(string: request.baseURL)?.appendingPathComponent(request.url) else {
            completion(.error(NetworkError(.invalidURL)))
            return
        }

        AF.request(url, method: request.method, parameters: request.params)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let answer):
                    completion(.success(answer))
                case .failure:

                    // TODO: add Alamofire error handling

                    completion(.error(NetworkError(error)))
                }
            }
    }
}
