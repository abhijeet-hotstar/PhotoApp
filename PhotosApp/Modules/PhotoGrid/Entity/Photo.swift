//
//  Photo.swift
//  PhotosApp
//
//  Created by Abhijeet Rai on 23/12/23.
//

import Foundation

struct Photo {
    let photoId: String
    let author: String
    let width: Int
    let height: Int
    let downloadUrl: String
    
    func generateThumbnailUrl(size: CGSize) -> String {
        let originalSize = CGSize(width: CGFloat(width), height: CGFloat(height))
        let aspectFitSize = originalSize.aspectFitSize(for: size)
        
        return downloadUrl.replacingOccurrences(of: "\(width)/\(height)", 
                                                with: "\(Int(aspectFitSize.width))/\(Int(aspectFitSize.height))")
    }
}

extension Photo: Decodable {
    enum CodingKeys: String, CodingKey {
        case photoId = "id"
        case author
        case width
        case height
        case downloadUrl = "download_url"
    }
}

extension Photo: Equatable {
    static func ==(lhs: Photo, rhs: Photo) -> Bool {
        return lhs.photoId == rhs.photoId
    }
}

