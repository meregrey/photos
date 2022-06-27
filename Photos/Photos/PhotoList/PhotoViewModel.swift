//
//  PhotoViewModel.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/06/24.
//

import UIKit.UIImage

final class PhotoViewModel {
    let image: UIImage
    let userName: String
    
    init?(photo: Photo) {
        guard let url = photo.url else { return nil }
        guard let image = ImageLoader.shared.image(for: url) else { return nil }
        self.image = image
        self.userName = photo.userName
    }
}
