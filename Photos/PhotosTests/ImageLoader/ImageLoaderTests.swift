//
//  ImageLoaderTests.swift
//  PhotosTests
//
//  Created by Yeojin Yoon on 2022/07/13.
//

@testable import Photos
import XCTest

final class ImageLoaderTests: XCTestCase {
    private var sut: ImageLoader!
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testLoadImages() {
        // given
        let cache = Cache<URL, ImageLoader.LoadingStatus>()
        let url = URL(string: "test.com")!
        cache[url] = .completed(UIImage())
        sut = ImageLoader(cache: cache)
        
        // when
        sut.loadImages(from: [url]) {
            // then
            let image = self.sut.image(for: url)
            XCTAssertNotNil(image)
        }
    }
}
