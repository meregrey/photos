//
//  APIKind.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/06/23.
//

import Foundation

enum APIKind {
    case listPhotos(page: Int, countPerPage: Int)
    
    var path: String {
        switch self {
        case .listPhotos:
            return "photos"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .listPhotos(let page, let countPerPage):
            return [URLQueryItem(name: "page", value: "\(page)"),
                    URLQueryItem(name: "per_page", value: "\(countPerPage)")]
        }
    }
}
