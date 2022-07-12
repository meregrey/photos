//
//  PhotoListViewModelTests.swift
//  PhotosTests
//
//  Created by Yeojin Yoon on 2022/06/23.
//

@testable import Photos
import XCTest

final class PhotoListViewModelTests: XCTestCase {
    private var sut: PhotoListViewModel!
    private var dataLoader: MockDataLoader!
    private var imageLoader: MockImageLoader!
    
    override func setUp() {
        super.setUp()
        dataLoader = MockDataLoader()
        imageLoader = MockImageLoader()
        sut = PhotoListViewModel(countPerPage: 1, dataLoader: dataLoader, imageLoader: imageLoader)
    }
    
    override func tearDown() {
        sut = nil
        imageLoader = nil
        dataLoader = nil
        super.tearDown()
    }
    
    func testFetchPhotos() {
        // given
        let data = """
        [
            {
                "urls": {
                    "regular": "test.com"
                },
                "user": {
                    "name": "name_0"
                }
            }
        ]
        """.data(using: .utf8)!
        let photos = try! JSONDecoder().decode([Photo].self, from: data)
        dataLoader.photos = photos
        let expectation = XCTestExpectation()
        
        sut.photoList.bind {
            if $0.photos.count == 0 { return }
            // then
            XCTAssertEqual($0.photos.first?.userName, "name_0")
            expectation.fulfill()
        }
        
        // when
        sut.fetchPhotos { _ in }
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchPhotosWithFailure() {
        // given
        dataLoader.photos = nil
        let expectation = XCTestExpectation()
        
        // when
        sut.fetchPhotos {
            // then
            XCTAssertEqual($0.message, LoadingError.noData.message)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
