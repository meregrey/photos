//
//  ImageLoader.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/06/23.
//

import UIKit.UIImage

@globalActor
actor ImageLoader: ImageLoadable {
    static let shared = ImageLoader()
    
    private let cache: Cache<URL, LoadingStatus<UIImage>>
    
    init(cache: Cache<URL, LoadingStatus<UIImage>> = .init()) {
        self.cache = cache
    }
    
    func loadImages(from urls: [URL]) async {
        await withTaskGroup(of: Void.self) { group in
            for url in urls {
                guard cache[url] == nil else { continue }
                group.addTask {
                    await self.loadImage(from: url)
                }
            }
        }
    }
    
    nonisolated func image(for url: URL) -> UIImage? {
        switch cache[url] {
        case .completed(let image):
            return image
        default:
            return nil
        }
    }
    
    private func loadImage(from url: URL) async {
        let task: Task<UIImage, Error> = Task {
            guard let data = try? Data(contentsOf: url) else { throw LoadingError.invalidURL }
            guard let image = UIImage(data: data)?.scaledToScreenWidth() else { throw LoadingError.invalidImageData }
            return image
        }
        
        do {
            cache[url] = .inProgress
            let image = try await task.value
            cache[url] = .completed(image)
        } catch {
            cache[url] = .failed
        }
    }
}
