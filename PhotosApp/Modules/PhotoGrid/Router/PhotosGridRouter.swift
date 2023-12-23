//
//  PhotosGridRouter.swift
//  PhotosApp
//
//  Created by Abhijeet Rai on 23/12/23.
//

import UIKit

class PhotosGridRouter: PhotosGridRoutable {
    
    static func createModule() -> PhotosGridViewable {
        let view = PhotosGridViewController()
        let presenter = PhotosGridPresenter()
        let interactor = PhotosGridInteractor()
        let router = PhotosGridRouter()
        
        view.presenter = presenter
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        
        interactor.presenter = presenter
        
        return view
    }
    
    func showPhoto(selectedPhoto: Photo, list: [Photo], over: (Navigatable & TransitionDelegate)?) {
        let photoEntity = PhotoViewerEntity(selectedPhoto: selectedPhoto, photosList: list)
        let photoViewer = PhotoViewerRouter.createModule(photoEntity: photoEntity, transitionDelegate: over)
        over?.present(photoViewer, animated: true, completion: nil)
    }
}
