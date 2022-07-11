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
    
    override func setUp() {
        super.setUp()
        dataLoader = MockDataLoader()
        sut = PhotoListViewModel(countPerPage: 1, dataLoader: dataLoader)
    }
    
    override func tearDown() {
        sut = nil
        dataLoader = nil
        super.tearDown()
    }
    
    func testFetchPhotos() async throws {
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
        
        do {
            // when
            try await sut.fetchPhotos()
            // then
            XCTAssertEqual(sut.photoList.value.photos.first?.userName, "name_0")
        } catch {
            XCTFail()
        }
    }
    
    func testFetchPhotosWithFailure() async throws {
        // given
        dataLoader.photos = nil
        
        do {
            // when
            try await sut.fetchPhotos()
            XCTFail()
        } catch {
            // then
            XCTAssertTrue(error is LoadingError)
        }
    }
}
