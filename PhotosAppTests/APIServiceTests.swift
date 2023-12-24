//
//  APIServiceTests.swift
//  PhotosAppTests
//
//  Created by Abhijeet Rai on 24/12/23.
//

import XCTest
import Combine
@testable import PhotosApp

class APIServiceTests: XCTestCase {
    
    struct MockRequest: RequestType {
        let url: URL
        let httpMethod: HttpMethod
        let body: Data?
        let headers: [String: String]?
    }
    
    func testRequestSuccess() {
        // Given
        let expectation = self.expectation(description: "API request successful")
        let sut = APIService()
        let url = URL(string: Constants.fetchListUrl)
        XCTAssertNotNil(url)
        let mockRequest = MockRequest(url: url!, httpMethod: .get, body: nil, headers: nil)
        
        // When
        let cancellable = sut.request(mockRequest)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        expectation.fulfill()
                    case .failure:
                        XCTFail("API request should succeed")
                }
            }, receiveValue: { _ in })
        
        // Then
        waitForExpectations(timeout: 5, handler: nil)
        cancellable.cancel()
    }
    
    func testRequestFailure() {
        // Given
        let expectation = self.expectation(description: "API request failed")
        let sut = APIService()
        let url = URL(string: "http://invalidurl/")
        XCTAssertNotNil(url)
        let mockRequest = MockRequest(url: url!, httpMethod: .get, body: nil, headers: nil)
        
        // When
        let cancellable = sut.request(mockRequest)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        XCTFail("API request should fail")
                    case .failure:
                        expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("No data should be received on failure")
            })
        
        // Then
        waitForExpectations(timeout: 5, handler: nil)
        cancellable.cancel()
    }
}
