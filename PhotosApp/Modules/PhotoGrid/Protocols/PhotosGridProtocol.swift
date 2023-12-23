//
//  PhotosGridProtocol.swift
//  PhotosApp
//
//  Created by Abhijeet Rai on 23/12/23.
//

import UIKit

protocol PhotosGridViewable: AnyObject, Navigatable, TransitionDelegate {
    func displayPhotos(_ list: [Photo])
    func displayError(_ error: Error)
}

protocol PhotosGridInteractable: AnyObject {
    var presenter: PhotosGridPresentable? { get }
    func fetchPhotos()
}

protocol PhotosGridPresentable: AnyObject {
    var view: PhotosGridViewable? { get }
    func viewDidLoad()
    func didSelectPhoto(_ photo: Photo, formList list: [Photo])
}

protocol PhotosGridRoutable: AnyObject {
    func showPhoto(selectedPhoto: Photo, list: [Photo], over: (Navigatable & TransitionDelegate)?)
}

protocol TransitionDelegate: AnyObject {
    func selectedphoto(_ photo: Photo)
}
