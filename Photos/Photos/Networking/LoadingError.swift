//
//  LoadingError.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/06/23.
//

import Foundation

enum LoadingError: Error {
    case invalidImageData
    case invalidRequest
    case invalidURL
    case requestFailed
    
    var localizedDescription: String {
        switch self {
        case .invalidImageData:
            return "이미지 데이터가 유효하지 않습니다."
        case .invalidRequest:
            return "요청이 유효하지 않습니다."
        case .invalidURL:
            return "URL이 유효하지 않습니다."
        case .requestFailed:
            return "요청이 실패했습니다."
        }
    }
}
