//
//  ImageLoaderServiceTests.swift
//  PhotosAppTests
//
//  Created by Abhijeet Rai on 24/12/23.
//

import XCTest
import Combine
@testable import PhotosApp

class ImageLoaderServiceTests: XCTestCase {
    
    func testLoadImageSuccess() {
        // Given
        let expectation = self.expectation(description: "Image load successful")
        let mockAPIService = MockAPIService()
        mockAPIService.data = getMockData()
        let imageLoaderService = ImageLoaderService(service: mockAPIService)
        let imageURL = URL(string: "https://picsum.photos/id/0/5000/3333")!
        
        // When
        var receivedResult: Result<UIImage, APIError>?
        imageLoaderService.loadImage(from: imageURL) { result in
            receivedResult = result
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNotNil(receivedResult, "Result should not be nil")
        switch receivedResult {
            case .success(let image):
                XCTAssertNotNil(image, "Image should not be nil")
            case .failure(let error):
                XCTFail("Unexpected error: \(error)")
            case .none:
                XCTFail("No value recieved")
        }
    }
    
    func testLoadImageFailure() {
        // Given
        let expectation = self.expectation(description: "Image load failed")
        let mockAPIService = MockAPIService()
        mockAPIService.error = APIError.requestFailed(NSError(domain: "TestDomain", code: 500, userInfo: nil))
        let imageLoaderService = ImageLoaderService(service: mockAPIService)
        let imageURL = URL(string: "https://picsum.photos/id/")!
        
        // When
        var receivedResult: Result<UIImage, APIError>?
        imageLoaderService.loadImage(from: imageURL) { result in
            receivedResult = result
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNotNil(receivedResult, "Result should not be nil")
        switch receivedResult {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "The operation couldn’t be completed. (PhotosApp.APIError error 0.)")
            case .none:
                XCTFail("No value recieved")
        }
    }
    
    func getMockData() -> Data? {
        Data(base64Encoded: "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAERlWElmTU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAAAaADAAQAAAABAAAAAQAAAAD5Ip3+AAAADUlEQVQIHWP4v5ThPwAG7wKkSFotfwAAAABJRU5ErkJggg==",
             options: .ignoreUnknownCharacters)
    }
}
