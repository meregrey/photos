//
//  DataLoaderTests.swift
//  PhotosTests
//
//  Created by Yeojin Yoon on 2022/06/23.
//

@testable import Photos
import XCTest

final class DataLoaderTests: XCTestCase {
    private var sut: DataLoader!
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        sut = DataLoader(urlSession: urlSession)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testFetch() {
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
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url?.query, "page=1&per_page=1")
            return (data, URLResponse())
        }
        let endpoint = Endpoint(for: .listPhotos(page: 1, countPerPage: 1))
        let expectation = XCTestExpectation()
        
        // when
        sut.fetch(with: endpoint) { (result: Result<[Photo], LoadingError>) in
            // then
            switch result {
            case .success(let photos):
                XCTAssertEqual(photos.first?.userName, "name_0")
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchWithFailure() {
        // given
        let data = """
        [
            {
                "id": "id_0"
            }
        ]
        """.data(using: .utf8)!
        MockURLProtocol.requestHandler = { _ in
            return (data, URLResponse())
        }
        let endpoint = Endpoint(for: .listPhotos(page: 1, countPerPage: 1))
        let expectation = XCTestExpectation()
        
        // when
        sut.fetch(with: endpoint) { (result: Result<[Photo], LoadingError>) in
            // then
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error.message, LoadingError.decodingFailed.message)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1)
    }
}
