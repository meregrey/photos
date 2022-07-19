//
//  LoadingStatus.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/07/19.
//

import Foundation

enum LoadingStatus<Item> {
    case inProgress
    case completed(Item)
    case failed
}
