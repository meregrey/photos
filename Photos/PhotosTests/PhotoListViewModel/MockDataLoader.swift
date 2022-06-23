//
//  MockDataLoader.swift
//  PhotosTests
//
//  Created by Yeojin Yoon on 2022/06/23.
//

@testable import Photos
import Foundation

final class MockDataLoader: DataLoadable {
    var photos: [Photo]?
    
    func fetch<T: Decodable>(with endpoint: Endpoint, completion: @escaping (Result<T, LoadingError>) -> Void) {
        if let photos = photos {
            completion(.success(photos as! T))
        } else {
            completion(.failure(.noData))
        }
    }
}
