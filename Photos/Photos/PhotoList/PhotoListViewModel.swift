//
//  PhotoListViewModel.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/06/23.
//

import Foundation

final class PhotoListViewModel {
    let photoList: Observable<(photos: [Photo], latestRange: Range<Int>)> = Observable(([], 0..<0))
    
    private let countPerPage: Int
    private let dataLoader: DataLoadable
    private let imageLoader: ImageLoadable
    
    private var page: Int = 1
    private var photosToAppend: [Photo] = [] {
        didSet {
            guard photosToAppend.count == countPerPage else { return }
            photoList.value = makePhotoList()
            page += 1
            photosToAppend = []
        }
    }
    
    init(countPerPage: Int = 10,
         dataLoader: DataLoadable = DataLoader(),
         imageLoader: ImageLoadable = ImageLoader.shared) {
        self.countPerPage = countPerPage
        self.dataLoader = dataLoader
        self.imageLoader = imageLoader
    }
    
    func fetchPhotos(errorHandler: @escaping (LoadingError) -> Void) {
        let endpoint = Endpoint(for: .listPhotos(page: page, countPerPage: countPerPage))
        
        dataLoader.fetch(with: endpoint) { (result: Result<[Photo], LoadingError>) in
            switch result {
            case .success(let photos):
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
    
    private func makePhotoList() -> ([Photo], Range<Int>) {
        let existingCount = photoList.value.photos.count
        let range = existingCount..<(existingCount + countPerPage)
        var photos = photoList.value.photos
        photos.append(contentsOf: photosToAppend)
        return (photos, range)
    }
}
