//
//  APIKind.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/06/23.
//

import Foundation

enum APIKind {
    case listPhotos(page: Int)
    
    var path: String {
        switch self {
        case .listPhotos: return "photos"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .listPhotos(let page): return [URLQueryItem(name: "page", value: "\(page)")]
        }
    }
}
