//
//  AspectFitSize.swift
//  PhotosApp
//
//  Created by Abhijeet Rai on 23/12/23.
//

import Foundation

extension CGSize {
    func aspectFitSize(for boundingSize: CGSize) -> CGSize {
        let aspectWidth = boundingSize.width / width
        let aspectHeight = boundingSize.height / height
        let aspectRatio = max(aspectWidth, aspectHeight)
        
        return CGSize(width: width * aspectRatio, height: height * aspectRatio)
    }
}
