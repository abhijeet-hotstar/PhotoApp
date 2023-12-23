//
//  PhotoCell.swift
//  PhotosApp
//
//  Created by Abhijeet Rai on 23/12/23.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    static let reuseIdentifier = "PhotoCell"
    private var currentPhoto: Photo?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
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
        contentView.addSubview(imageView)
        contentView.addSubview(activityIndicator)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with photo: Photo) {
        imageView.image = nil
        currentPhoto = photo
        activityIndicator.startAnimating()
        
        if let imageUrl = URL(string: photo.generateThumbnailUrl(size: frame.size)) {
            ImageLoaderService.shared.loadImage(from: imageUrl) { [weak self] result in
                guard self?.currentPhoto == photo else {
                    // Cell has been reused, do not update the image
                    return
                }
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
