//
//  MockURLSession.swift
//  PhotosTests
//
//  Created by Yeojin Yoon on 2022/07/11.
//

@testable import Photos
import Foundation

final class MockURLSession: URLSessionType {
    var data: Data?
    
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        let response = HTTPURLResponse(url: URL(string: "test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        return (data!, response!)
    }
}
