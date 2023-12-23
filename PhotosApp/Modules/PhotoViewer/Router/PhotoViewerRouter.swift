//
//  PhotoViewerRouter.swift
//  PhotosApp
//
//  Created by Abhijeet Rai on 23/12/23.
//

import Foundation

class PhotoViewerRouter: PhotoViewerRoutable {
    
    static func createModule(photoEntity: PhotoViewerEntity, transitionDelegate: TransitionDelegate?) -> PhotoViewerViewable {
        let view = PhotoViewerViewController()
        let presenter = PhotoViewerPresenter()
        let interactor = PhotoViewerInteractor(photoEntity: photoEntity, transitionDelegate: transitionDelegate)
        let router = PhotoViewerRouter()
        
        view.presenter = presenter
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        
        interactor.presenter = presenter
        
        return view
    }
    
    func dismissPhotoViewer(navigatable: Navigatable?) {
        navigatable?.dismiss(animated: true, completion: nil)
    }
}
