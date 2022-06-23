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
    
    private let countPerPage: Int
    private let dataLoader: DataLoadable
    private let imageLoader: ImageLoadable
    
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
    
    init(countPerPage: Int = 10,
         dataLoader: DataLoadable = DataLoader(),
         imageLoader: ImageLoadable = ImageLoader()) {
        self.countPerPage = countPerPage
        self.dataLoader = dataLoader
        self.imageLoader = imageLoader
    }
    
    func fetchPhotos(errorHandler: @escaping (LoadingError) -> Void) {
        let endpoint = Endpoint(for: .listPhotos(page: page, countPerPage: countPerPage))
        
        dataLoader.fetch(with: endpoint) { (result: Result<[Photo], LoadingError>) in
            switch result {
            case .success(let photos):
                self.isLoading.value = true
                photos.forEach { photo in
                    guard let url = photo.url else { return }
                    self.imageLoader.loadImage(for: url) { result in
                        switch result {
                        case .success(_):
                            self.photosToAppend.append(photo)
                        case .failure(let error):
                            errorHandler(error)
                        }
                    }
                }
            case .failure(let error):
                errorHandler(error)
            }
        }
    }
}
