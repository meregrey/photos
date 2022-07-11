//
//  URLSessionType.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/07/11.
//

import Foundation

protocol URLSessionType {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}
