//
//  PhotoViewerViewController.swift
//  PhotosApp
//
//  Created by Abhijeet Rai on 23/12/23.
//

import UIKit

class PhotoViewerViewController: UIViewController, PhotoViewerViewable {
    
    var presenter: PhotoViewerPresentable?
    
    private var photoViewerItemView: PhotoViewerItemView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPhotoViewer()
        setupCloseButton()
        configureSwipeGestures()
        
        presenter?.viewDidLoad()
    }
    
    private func setupPhotoViewer() {
        photoViewerItemView = PhotoViewerItemView()
        view.addSubview(photoViewerItemView!)
        view.backgroundColor = .gray
        photoViewerItemView!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoViewerItemView!.topAnchor.constraint(equalTo: view.topAnchor),
            photoViewerItemView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoViewerItemView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoViewerItemView!.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupCloseButton() {
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: Constants.closeButtonName), for: .normal)
        closeButton.tintColor = UIColor.black
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            closeButton.widthAnchor.constraint(equalToConstant: 30.0),
            closeButton.heightAnchor.constraint(equalToConstant: 30.0)
        ])
    }
    
    private func configureSwipeGestures() {
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft))
        swipeLeftGesture.direction = .left
        view.addGestureRecognizer(swipeLeftGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeRight))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
    }
    
    func showPhoto(_ photo: Photo) {
        photoViewerItemView?.configure(with: photo)
    }
    
    // MARK: - Swipe Gesture Handlers
    
    @objc private func didSwipeLeft() {
        presenter?.didSwipeLeft()
    }
    
    @objc private func didSwipeRight() {
        presenter?.didSwipeRight()
    }
    
    // MARK: - PhotoViewerViewable
    
    @objc private func closeButtonTapped() {
        presenter?.closeButtonTapped()
    }
}
