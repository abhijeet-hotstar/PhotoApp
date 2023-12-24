//
//  MockAPIService.swift
//  PhotosAppTests
//
//  Created by Abhijeet Rai on 24/12/23.
//

import XCTest
import Combine
@testable import PhotosApp

class MockAPIService: APIServicable {
    
    var data: Data?
    var error: APIError?
    var mockData: String?
    
    func request<T: RequestType>(_ request: T) -> AnyPublisher<Data, APIError> {
        
        if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        } else if let data = data {
            return Just(data)
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        } else if let mockData = mockData?.data(using: .utf8) {
            return Just(mockData)
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
    }
}
