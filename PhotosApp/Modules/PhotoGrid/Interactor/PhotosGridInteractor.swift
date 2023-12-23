//
//  PhotosGridInteractor.swift
//  PhotosApp
//
//  Created by Abhijeet Rai on 23/12/23.
//

import Foundation

class PhotosGridInteractor: PhotosGridInteractable {
    
    weak var presenter: PhotosGridPresentable?

    let imageLoaderService = ImageLoaderService()
    let photoListAPIService = PhotoListAPIService()

    func fetchPhotos() {
        photoListAPIService.getPhotos {[weak self] result in
            switch result {
                case .success(let photos):
                    self?.presenter?.view?.displayPhotos(photos)
                case .failure(let error):
                    self?.presenter?.view?.displayError(error)
            }
        }
    }
}
