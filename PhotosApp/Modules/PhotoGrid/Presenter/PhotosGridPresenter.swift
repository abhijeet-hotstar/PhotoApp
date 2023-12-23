//
//  PhotosGridPresenter.swift
//  PhotosApp
//
//  Created by Abhijeet Rai on 23/12/23.
//

import Foundation

class PhotosGridPresenter: PhotosGridPresentable {
    
    weak var view: PhotosGridViewable?
    
    var interactor: PhotosGridInteractable?
    var router: PhotosGridRoutable?
    
    func viewDidLoad() {
        interactor?.fetchPhotos()
    }
    
    func didSelectPhoto(_ photo: Photo, formList list: [Photo]) {
        router?.showPhoto(selectedPhoto: photo, list: list, over: view)
    }
}
