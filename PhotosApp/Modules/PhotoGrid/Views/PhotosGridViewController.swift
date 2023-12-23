//
//  PhotosGridViewController.swift
//  PhotosApp
//
//  Created by Abhijeet Rai on 23/12/23.
//

import UIKit

class PhotosGridViewController: UIViewController, PhotosGridViewable {
    
    var presenter: PhotosGridPresentable?
    var thumnailSize: CGSize = .zero
    
    private var photos: [Photo] = []
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    func setupUI() {
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Update the collection view layout on screen rotation
        coordinator.animate(alongsideTransition: { _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
    
    func presentErrorAlert(_ error: Error) {
        let alert = UIAlertController(title: Constants.errorTitle, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.okTitle, style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    func selectedphoto(_ photo: Photo) {
        guard let index = photos.firstIndex(of: photo) else {
            return
        }
        
        let indexPath = IndexPath(item: index, section: 0)
        if !collectionView.indexPathsForVisibleItems.contains(indexPath) {
            collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        }
    }
    
    // MARK: - PhotosGridViewable
    
    func displayPhotos(_ list: [Photo]) {
        self.photos = list
        collectionView.reloadData()
    }
    
    func displayError(_ error: Error) {
        presentErrorAlert(error)
    }
}

extension PhotosGridViewController: UICollectionViewDataSource, UICollectionViewDataSourcePrefetching, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        let photo = photos[indexPath.item]
        cell.configure(with: photo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPhoto = photos[indexPath.item]
        presenter?.didSelectPhoto(selectedPhoto, formList: photos)
    }
    
    // MARK: - UICollectionViewDataSourcePrefetching
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        // Prefetch images for the upcoming cells
        for indexPath in indexPaths {
            let photo = photos[indexPath.item]
            if let imageUrl = URL(string: photo.generateThumbnailUrl(size: thumnailSize)) {
                ImageLoaderService.shared.loadImage(from: imageUrl) { _ in
                    // Images are prefetched and cached, no need to do anything here
                }
            }
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = calculateNumberOfColumns()
        
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            // Calculate total spacing between cells
            let totalSpacing = (numberOfColumns - 1) * flowLayout.minimumInteritemSpacing
            
            // Calculate width of each cell considering spacing
            let cellWidth = (collectionView.bounds.width - totalSpacing) / numberOfColumns
            thumnailSize = CGSize(width: cellWidth, height: cellWidth)
            return thumnailSize
        }
        return CGSize(width: 200, height: 200)
    }
    
    private func calculateNumberOfColumns() -> CGFloat {
        let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        let isLandscape = orientation == .landscapeLeft || orientation == .landscapeRight
        return isLandscape ? 6 : 3
    }
}
