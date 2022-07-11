//
//  DataLoader.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/06/23.
//

import Foundation

struct DataLoader: DataLoadable {
    private let urlSession: URLSessionType
    
    init(urlSession: URLSessionType = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func fetch<T: Decodable>(with endpoint: Endpoint) async throws -> T {
        guard let request = endpoint.makeRequest() else { throw LoadingError.invalidRequest }
        let (data, response) = try await urlSession.data(for: request, delegate: nil)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw LoadingError.requestFailed }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
