//
//  PhotoViewerProtocol.swift
//  PhotosApp
//
//  Created by Abhijeet Rai on 23/12/23.
//

import Foundation

protocol PhotoViewerViewable: AnyObject, Navigatable {    
    func showPhoto(_ photo: Photo)
}

protocol PhotoViewerInteractable: AnyObject {
    var transitionDelegate: TransitionDelegate? { get set }
    func getCurrentPhoto() -> Photo
    func photoDidSwipeLeft()
    func photoDidSwipeRight()
}

protocol PhotoViewerPresentable: AnyObject {
    func viewDidLoad()
    func loadPhoto(_ photo: Photo)
    func didSwipeLeft()
    func didSwipeRight()
    func closeButtonTapped()
}

protocol PhotoViewerRoutable: AnyObject {
    func dismissPhotoViewer(navigatable: Navigatable?)
}
