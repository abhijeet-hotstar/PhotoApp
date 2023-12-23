//
//  PhotoViewerInteractor.swift
//  PhotosApp
//
//  Created by Abhijeet Rai on 23/12/23.
//

import Foundation

class PhotoViewerInteractor: PhotoViewerInteractable {
    
    weak var presenter: PhotoViewerPresentable?
    weak var transitionDelegate: TransitionDelegate?
    private var photoEntity: PhotoViewerEntity
    
    init(photoEntity: PhotoViewerEntity, transitionDelegate: TransitionDelegate?) {
        self.photoEntity = photoEntity
        self.transitionDelegate = transitionDelegate
    }
    
    func getCurrentPhoto() -> Photo {
        return photoEntity.selectedPhoto
    }
    
    func photoDidSwipeLeft() {
        guard let currentIndex = photoEntity.photosList.firstIndex(of: photoEntity.selectedPhoto) else {
            return
        }
        
        let newIndex = currentIndex + 1
        if newIndex < photoEntity.photosList.count {
            updateImage(index: newIndex)
        }
    }
    
    func photoDidSwipeRight() {
        guard let currentIndex = photoEntity.photosList.firstIndex(of: photoEntity.selectedPhoto) else {
            return
        }
        
        let newIndex = currentIndex - 1
        if newIndex >= 0 && newIndex < photoEntity.photosList.count {
            updateImage(index: newIndex)
        }
    }
    
    func updateImage(index: Int) {
        photoEntity.selectedPhoto = photoEntity.photosList[index]
        transitionDelegate?.selectedphoto(photoEntity.selectedPhoto)
        presenter?.loadPhoto(photoEntity.selectedPhoto)
    }
}
