//
//  ImageLoader.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/06/23.
//

import UIKit.UIImage

struct ImageLoader: ImageLoadable {
    private let cache: Cache<URL, UIImage>
    
    init(cache: Cache<URL, UIImage> = .init()) {
        self.cache = cache
    }
    
    func loadImage(for url: URL, completion: @escaping (Result<UIImage, LoadingError>) -> Void) {
        if let cachedImage = cache[url] {
            completion(.success(cachedImage))
            return
        }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else {
                completion(.failure(.invalidURL))
                return
            }
            guard let image = UIImage(data: data)?.scaledToScreenWidth() else {
                completion(.failure(.invalidImageData))
                return
            }
            cache[url] = image
            completion(.success(image))
        }
    }
}
