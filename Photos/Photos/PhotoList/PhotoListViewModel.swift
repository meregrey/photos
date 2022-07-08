//
//  PhotoListViewModel.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/06/23.
//

import Foundation

final class PhotoListViewModel {
    let photoList: Observable<(photos: [Photo], latestRange: Range<Int>)> = Observable(([], 0..<0))
    let isLoading: Observable<Bool> = Observable(false)
    
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
    
    func fetchPhotos() async throws {
        isLoading.value = true
        let endpoint = Endpoint(for: .listPhotos(page: page, countPerPage: countPerPage))
        let photos: [Photo] = try await dataLoader.fetch(with: endpoint)
        let urls = photos.compactMap { $0.url }
        await imageLoader.loadImages(from: urls)
        photoList.value = makePhotoList(with: photos)
        isLoading.value = false
        page += 1
    }
    
    private func makePhotoList(with photosToAppend: [Photo]) -> ([Photo], Range<Int>) {
        let existingCount = photoList.value.photos.count
        let range = existingCount..<(existingCount + countPerPage)
        var photos = photoList.value.photos
        photos.append(contentsOf: photosToAppend)
        return (photos, range)
    }
}
