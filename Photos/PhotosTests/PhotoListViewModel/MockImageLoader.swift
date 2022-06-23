//
//  MockImageLoader.swift
//  PhotosTests
//
//  Created by Yeojin Yoon on 2022/06/23.
//

@testable import Photos
import UIKit.UIImage

final class MockImageLoader: ImageLoadable {
    func loadImage(for url: URL, completion: @escaping (Result<UIImage, LoadingError>) -> Void) {
        completion(.success(UIImage()))
    }
}
