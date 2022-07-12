//
//  ImageLoader.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/06/23.
//

import UIKit.UIImage

final class ImageLoader: ImageLoadable {
    static let shared = ImageLoader()
    
    enum LoadingStatus {
        case inProgress
        case completed(UIImage)
        case failed
    }
    
    private let cache: Cache<URL, LoadingStatus>
    
    init(cache: Cache<URL, LoadingStatus> = .init()) {
        self.cache = cache
    }
    
    func loadImages(from urls: [URL], completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        DispatchQueue.concurrentPerform(iterations: urls.count) { index in
            let url = urls[index]
            guard cache[url] == nil else { return }
            dispatchGroup.enter()
            loadImage(from: url) {
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.global()) {
            completion()
        }
    }
    
    func image(for url: URL) -> UIImage? {
        switch cache[url] {
        case .completed(let image):
            return image
        default:
            return nil
        }
    }
    
    private func loadImage(from url: URL, completion: @escaping () -> Void) {
        do {
            cache[url] = .inProgress
            let data = try Data(contentsOf: url)
            guard let image = UIImage(data: data)?.scaledToScreenWidth() else { throw LoadingError.invalidImageData }
            cache[url] = .completed(image)
            completion()
        } catch {
            cache[url] = .failed
            completion()
        }
    }
}
