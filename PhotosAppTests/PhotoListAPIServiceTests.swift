//
//  PhotoListAPIServiceTests.swift
//  PhotosAppTests
//
//  Created by Abhijeet Rai on 24/12/23.
//

import XCTest
import Combine
@testable import PhotosApp

class PhotoListAPIServiceTests: XCTestCase {
    
    func testGetPhotos() {
        // Given
        let expectation = self.expectation(description: "API request successful")
        let mockAPIService = MockAPIService()
        mockAPIService.mockData = getMockData()
        let photoListAPIService = PhotoListAPIService(service: mockAPIService)
        
        // When
        var receivedResult: Result<[Photo], Error>?
        photoListAPIService.getPhotos { result in
            receivedResult = result
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNotNil(receivedResult, "Result should not be nil")
        switch receivedResult {
            case .success(let photos):
                XCTAssertEqual(photos.count, 4, "Number of photos should match the mock data")
            case .failure(let error):
                XCTFail("Unexpected error \(error.localizedDescription)")
            case .none:
                XCTFail("No value recieved")
        }
    }
    
    func getMockData() -> String {
        """
            [
                {
                    "id": "0",
                    "author": "Alejandro Escamilla",
                    "width": 5000,
                    "height": 3333,
                    "download_url": "https://picsum.photos/id/0/5000/3333"
                },
                {
                    "id": "1",
                    "author": "Alejandro Escamilla",
                    "width": 5000,
                    "height": 3333,
                    "download_url": "https://picsum.photos/id/1/5000/3333"
                },
                {
                    "id": "2",
                    "author": "Alejandro Escamilla",
                    "width": 5000,
                    "height": 3333,
                    "download_url": "https://picsum.photos/id/2/5000/3333"
                },
                {
                    "id": "3",
                    "author": "Alejandro Escamilla",
                    "width": 5000,
                    "height": 3333,
                    "download_url": "https://picsum.photos/id/3/5000/3333"
                }
            ]
        """
    }
}
