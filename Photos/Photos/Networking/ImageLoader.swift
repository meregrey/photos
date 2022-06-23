//
//  ImageLoader.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/06/23.
//

import UIKit.UIImage

struct ImageLoader: ImageLoadable {
    let cache = Cache<URL, UIImage>()
    let dataLoader: DataLoadable
    
    init(dataLoader: DataLoadable = DataLoader()) {
        self.dataLoader = dataLoader
    }
    
    func loadImage(for url: URL, completion: @escaping () -> Void) {
        guard cache[url] == nil else {
            completion()
            return
        }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            guard let image = UIImage(data: data)?.scaledToScreenWidth() else { return }
            cache[url] = image
            completion()
        }
    }
}
