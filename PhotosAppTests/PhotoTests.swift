//
//  PhotoTests.swift
//  PhotosAppTests
//
//  Created by Abhijeet Rai on 24/12/23.
//

import XCTest
@testable import PhotosApp

class PhotoTests: XCTestCase {
    
    func testGenerateThumbnailUrl() {
        // Given
        let photo = Photo(photoId: "0",
                          author: "Alejandro Escamilla",
                          width: 5000,
                          height: 3333,
                          downloadUrl: "https://picsum.photos/id/0/5000/3333")
        let thumbnailSize = CGSize(width: 200, height: 200)
        
        // When
        let thumbnailUrl = photo.generateThumbnailUrl(size: thumbnailSize)
        
        // Then
        let expectedThumbnailUrl = "https://picsum.photos/id/0/300/200"
        XCTAssertEqual(thumbnailUrl, expectedThumbnailUrl, "Generated thumbnail URL should match the expected URL")
    }
    
    func testDecoding() {
        // Given
        let json = """
        {
            "id": "0",
            "author": "Alejandro Escamilla",
            "width": 5000,
            "height": 3333,
            "download_url": "https://picsum.photos/id/0/5000/3333"
        }
        """.data(using: .utf8)!
        
        // When
        let decodedPhoto = try? JSONDecoder().decode(Photo.self, from: json)
        
        // Then
        XCTAssertNotNil(decodedPhoto, "Decoding should succeed")
        XCTAssertEqual(decodedPhoto?.photoId, "0", "Decoded photo ID should match")
        XCTAssertEqual(decodedPhoto?.author, "Alejandro Escamilla", "Decoded author should match")
        XCTAssertEqual(decodedPhoto?.width, 5000, "Decoded width should match")
        XCTAssertEqual(decodedPhoto?.height, 3333, "Decoded height should match")
        XCTAssertEqual(decodedPhoto?.downloadUrl, "https://picsum.photos/id/0/5000/3333", "Decoded download URL should match")
    }
    
    func testEquatable() {
        // Given
        let photo1 = Photo(photoId: "9", 
                           author: "Alejandro Escamilla",
                           width: 5000,
                           height: 3269,
                           downloadUrl: "https://picsum.photos/id/9/5000/3269")
        
        let photo2 = Photo(photoId: "9",
                           author: "Alejandro Escamilla",
                           width: 5000,
                           height: 3269,
                           downloadUrl: "https://picsum.photos/id/9/5000/3269")
        
        let photo3 = Photo(photoId: "10",
                           author: "Paul Jarvis",
                           width: 2500,
                           height: 1667,
                           downloadUrl: "https://picsum.photos/id/10/2500/1667")
        
        // Then
        XCTAssertEqual(photo1, photo2, "Photos with the same ID should be equal")
        XCTAssertNotEqual(photo1, photo3, "Photos with different IDs should not be equal")
    }
}
