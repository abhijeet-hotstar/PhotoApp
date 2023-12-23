//
//  PhotoViewerItemView.swift
//  PhotosApp
//
//  Created by Abhijeet Rai on 23/12/23.
//

import UIKit

class PhotoViewerItemView: UIView {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 4
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        scrollView.delegate = self
        addSubview(scrollView)
        scrollView.addSubview(imageView)
        addSubview(activityIndicator)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard scrollView.zoomScale > 1, let image = imageView.image else {
            scrollView.contentInset = .zero
            return
        }
        
        let ratioW = imageView.frame.width / image.size.width
        let ratioH = imageView.frame.height / image.size.height
        let ratio = min(ratioW, ratioH)
        
        let newWidth = image.size.width * ratio
        let newHeight = image.size.height * ratio
        
        let conditionLeft = newWidth * scrollView.zoomScale > imageView.frame.width
        let left = 0.5 * (conditionLeft ? newWidth - imageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
        
        let conditionTop = newHeight * scrollView.zoomScale > imageView.frame.height
        let top = 0.5 * (conditionTop ? newHeight - imageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
        
        scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
    }


    func configure(with photo: Photo) {
        imageView.image = nil
        activityIndicator.startAnimating()
        
        if let imageUrl = URL(string: photo.downloadUrl) {
            ImageLoaderService.shared.loadImage(from: imageUrl) { [weak self] result in
                switch result {
                    case .success(let image):
                        self?.imageView.image = image
                        self?.activityIndicator.stopAnimating()
                    case .failure(let error):
                        print("Failed to load image: \(error)")
                        self?.activityIndicator.stopAnimating()
                }
            }
        }
    }
}

extension PhotoViewerItemView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
