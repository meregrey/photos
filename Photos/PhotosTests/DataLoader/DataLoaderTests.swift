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
    private var urlSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        urlSession = MockURLSession()
        sut = DataLoader(urlSession: urlSession)
    }
    
    override func tearDown() {
        sut = nil
        urlSession = nil
        super.tearDown()
    }
    
    func testFetch() async throws {
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
        urlSession.data = data
        let endpoint = Endpoint(for: .listPhotos(page: 1, countPerPage: 1))
        
        do {
            // when
            let photos: [Photo] = try await sut.fetch(with: endpoint)
            // then
            XCTAssertEqual(photos.first?.userName, "name_0")
        } catch {
            XCTFail()
        }
        
    }
    
    func testFetchWithFailure() async throws {
        // given
        let data = """
        [
            {
                "id": "id_0"
            }
        ]
        """.data(using: .utf8)!
        urlSession.data = data
        let endpoint = Endpoint(for: .listPhotos(page: 1, countPerPage: 1))
        
        do {
            // when
            let _: [Photo] = try await sut.fetch(with: endpoint)
            XCTFail()
        } catch {
            // then
            XCTAssertTrue(error is DecodingError)
        }
    }
}
