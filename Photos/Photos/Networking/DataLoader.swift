//
//  DataLoader.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/06/23.
//

import Foundation

struct DataLoader: DataLoadable {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetch<T: Decodable>(with endpoint: Endpoint, completion: @escaping (Result<T, LoadingError>) -> Void) {
        guard let request = endpoint.makeRequest() else { return }
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.requestFailed(error: error!)))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            guard let result = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(.decodingFailed))
                return
            }
            completion(.success(result))
        }
        
        task.resume()
    }
}
