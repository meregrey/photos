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
                let urls = photos.compactMap { $0.url }
                self.imageLoader.loadImages(from: urls) {
                    self.photoList.value = self.makePhotoList(with: photos)
                    self.page += 1
                }
            case .failure(let error):
                errorHandler(error)
            }
        }
    }
    
    private func makePhotoList(with photosToAppend: [Photo]) -> ([Photo], Range<Int>) {
        let existingCount = photoList.value.photos.count
        let range = existingCount..<(existingCount + countPerPage)
        var photos = photoList.value.photos
        photos.append(contentsOf: photosToAppend)
        return (photos, range)
    }
}
