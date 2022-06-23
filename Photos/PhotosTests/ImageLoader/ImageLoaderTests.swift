//
//  ImageLoaderTests.swift
//  PhotosTests
//
//  Created by Yeojin Yoon on 2022/06/23.
//

@testable import Photos
import XCTest

final class ImageLoaderTests: XCTestCase {
    private var sut: ImageLoader!
    
    override func setUp() {
        super.setUp()
        sut = ImageLoader()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testLoadImage() {
        // given
        let cache = Cache<URL, UIImage>()
        let url = URL(string: "test.com")!
        cache[url] = UIImage()
        sut = ImageLoader(cache: cache)
        let expectation = XCTestExpectation()
        
        // when
        sut.loadImage(for: url) { result in
            // then
            switch result {
            case .success(let image):
                XCTAssertNotNil(image)
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testLoadImageWithFailure() {
        // given
        let url = URL(string: "test.com")!
        let expectation = XCTestExpectation()
        
        // when
        sut.loadImage(for: url) { result in
            // then
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error.message, LoadingError.invalidURL.message)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1)
    }
}
