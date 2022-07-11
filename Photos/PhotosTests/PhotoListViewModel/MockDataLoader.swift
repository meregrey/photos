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
    
    func fetch<T: Decodable>(with endpoint: Endpoint) async throws -> T {
        if let photos = photos {
            return photos as! T
        } else {
            throw LoadingError.requestFailed
        }
    }
}
