//
//  ImageLoaderService.swift
//  PhotosApp
//
//  Created by Abhijeet Rai on 23/12/23.
//

import UIKit
import Combine

struct ImageRequest: RequestType {
    var url: URL
    
    var httpMethod: HttpMethod {
        return .get
    }
    
    var body: Data? {
        return nil
    }
    
    var headers: [String: String]? {
        return nil
    }
}

class ImageLoaderService {
    
    static let shared = ImageLoaderService()
    
    private var imageCache = NSCache<NSString, UIImage>()
    private var cancellables: Set<AnyCancellable> = []
    private var inflightRequests: [URL: Publishers.Share<AnyPublisher<UIImage, APIError>>] = [:]
    
    func loadImage(from url: URL, completion: @escaping (Result<UIImage, APIError>) -> Void) {
        // Check if the image is already in the cache
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(.success(cachedImage))
        } else if let inflightRequest = inflightRequests[url] {
            // If a request is in flight, wait for its completion
            inflightRequest
                .sink(receiveCompletion: { _ in
                    // Remove the entry from inflightRequests when completed
                    self.inflightRequests[url] = nil
                }, receiveValue: { image in
                    completion(.success(image))
                })
                .store(in: &cancellables)
        } else {
            let publisher = downloadImage(from: url)
                .share() // Share the same download among multiple subscribers
            publisher
                .sink(receiveCompletion: { downloadCompletion in
                    switch downloadCompletion {
                        case .finished:
                            break
                        case .failure(let error):
                            completion(.failure(.requestFailed(error)))
                    }
                }, receiveValue: { downloadedImage in
                    // Cache the downloaded image
                    self.imageCache.setObject(downloadedImage, forKey: url.absoluteString as NSString)
                    completion(.success(downloadedImage))
                })
                .store(in: &cancellables)
            // Store the publisher in the inflightRequests dictionary
            inflightRequests[url] = publisher
        }
    }
    
    private func downloadImage(from url: URL) -> AnyPublisher<UIImage, APIError> {
        guard let imageUrl = URL(string: url.absoluteString) else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        let imageRequest = ImageRequest(url: imageUrl)
        return APIService.request(imageRequest)
            .receive(on: DispatchQueue.main)
            .tryMap { data in
                guard let image = UIImage(data: data) else {
                    throw APIError.invalidResponse
                }
                return image
            }
            .mapError { error in
                APIError.requestFailed(error)
            }
            .eraseToAnyPublisher()
    }
}
