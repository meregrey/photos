//
//  DataLoadable.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/06/23.
//

import Foundation

protocol DataLoadable {
    func fetch<T: Decodable>(with endpoint: Endpoint) async throws -> T
}
