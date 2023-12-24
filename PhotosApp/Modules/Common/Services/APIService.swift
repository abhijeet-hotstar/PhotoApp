//
//  APIService.swift
//  PhotosApp
//
//  Created by Abhijeet Rai on 23/12/23.
//

import Foundation
import Combine

// MARK: - Request Type Protocol

enum HttpMethod: String {
    case get
    case post
    case put
}

protocol RequestType {
    var url: URL { get }
    var httpMethod: HttpMethod { get }
    var body: Data? { get }
    var headers: [String: String]? { get }
}

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
}

protocol APIServicable {
    func request<T: RequestType>(_ request: T) -> AnyPublisher<Data, APIError>
}

class APIService: APIServicable {
    
    func request<T: RequestType>(_ request: T) -> AnyPublisher<Data, APIError> {
        guard let url = URL(string: request.url.absoluteString) else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue.uppercased()
        urlRequest.httpBody = request.body
        urlRequest.allHTTPHeaderFields = request.headers
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw APIError.invalidResponse
                }
                return data
            }
            .mapError { error in
                APIError.requestFailed(error)
            }
            .eraseToAnyPublisher()
    }
}
