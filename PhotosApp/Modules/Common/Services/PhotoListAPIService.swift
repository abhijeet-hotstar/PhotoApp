//
//  PhotoListAPIService.swift
//  PhotosApp
//
//  Created by Abhijeet Rai on 23/12/23.
//

import Foundation
import Combine

struct PhotosListRequest: RequestType {
    var url: URL {
        return URL(string: Constants.fetchListUrl)!
    }
    
    var httpMethod: HttpMethod {
        .get
    }
    
    var body: Data? {
        return nil
    }
    
    var headers: [String: String]? {
        return nil
    }
}

class PhotoListAPIService {
    
    private var cancellables: Set<AnyCancellable> = []
    
    func getPhotos(completion: @escaping (Result<[Photo], Error>) -> Void) {
        let request = PhotosListRequest()
        
        APIService.request(request)
            .decode(type: [Photo].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { response in
                switch response {
                    case .finished:
                        break
                    case .failure(let error):
                        completion(.failure(error))
                }
            }, receiveValue: { response in
                completion(.success(response))
            })
            .store(in: &cancellables)
    }
}
