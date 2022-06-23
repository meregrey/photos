//
//  PhotoListViewModel.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/06/23.
//

import Foundation

final class PhotoListViewModel {
    let photos: Observable<[Photo]> = Observable([])
    let isLoading: Observable<Bool> = Observable(false)
    let dataLoader: DataLoadable
    let imageLoader: ImageLoadable
    
    private let countPerPage = 10
    
    private var page = 1
    private var photosToAppend = [Photo]() {
        didSet {
            guard photosToAppend.count == countPerPage else { return }
            photos.value.append(contentsOf: photosToAppend)
            isLoading.value = false
            page += 1
            photosToAppend = []
        }
    }
    
    init(dataLoader: DataLoadable = DataLoader(), imageLoader: ImageLoadable = ImageLoader()) {
        self.dataLoader = dataLoader
        self.imageLoader = imageLoader
    }
    
    func fetchPhotos(errorHandler: @escaping (LoadingError) -> Void) {
        let endpoint = Endpoint(for: .listPhotos(page: page))
        
        dataLoader.fetch(with: endpoint) { (result: Result<[Photo], LoadingError>) in
            switch result {
            case .success(let photos):
                self.isLoading.value = true
                photos.forEach { photo in
                    guard let url = photo.url else { return }
                    self.imageLoader.loadImage(for: url) {
                        self.photosToAppend.append(photo)
                    }
                }
            case .failure(let error):
                errorHandler(error)
            }
        }
    }
}
