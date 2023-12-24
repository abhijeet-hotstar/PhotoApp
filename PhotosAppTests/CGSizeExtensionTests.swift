//
//  CGSizeExtensionTests.swift
//  PhotosAppTests
//
//  Created by Abhijeet Rai on 24/12/23.
//

import XCTest
@testable import PhotosApp

class CGSizeExtensionTests: XCTestCase {
    
    func testAspectFitSize() {
        // Given
        let originalSize = CGSize(width: 1600, height: 900)
        let boundingSize = CGSize(width: 200, height: 200)
        
        // When
        let resultSize = originalSize.aspectFitSize(for: boundingSize)
        
        // Then
        XCTAssertEqual(resultSize.width.rounded(), 356)
        XCTAssertEqual(resultSize.height.rounded(), 200)
    }
}
