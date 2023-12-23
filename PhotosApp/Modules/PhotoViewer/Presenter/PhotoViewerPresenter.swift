//
//  PhotoViewerPresenter.swift
//  PhotosApp
//
//  Created by Abhijeet Rai on 23/12/23.
//

import UIKit

class PhotoViewerPresenter: PhotoViewerPresentable {
    
    weak var view: PhotoViewerViewable?
    var interactor: PhotoViewerInteractable?
    var router: PhotoViewerRoutable?
    
    func viewDidLoad() {
        if let selectedPhoto = interactor?.getCurrentPhoto() {
            loadPhoto(selectedPhoto)
        }
    }
    
    func didSwipeLeft() {
        interactor?.photoDidSwipeLeft()
    }
    
    func didSwipeRight() {
        interactor?.photoDidSwipeRight()
    }
    
    func loadPhoto(_ photo: Photo) {
        view?.showPhoto(photo)
    }
    
    func closeButtonTapped() {
        router?.dismissPhotoViewer(navigatable: view)
    }
}
