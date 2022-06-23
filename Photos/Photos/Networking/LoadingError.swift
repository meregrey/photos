//
//  LoadingError.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/06/23.
//

import Foundation

enum LoadingError: Error {
    case requestFailed(error: Error)
    case noData
    case decodingFailed
    
    var message: String {
        switch self {
        case .requestFailed(let error): return error.localizedDescription
        case .noData: return "데이터가 존재하지 않습니다."
        case .decodingFailed: return "디코딩하던 중 에러가 발생했습니다."
        }
    }
}
