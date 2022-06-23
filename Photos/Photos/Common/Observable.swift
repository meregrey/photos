//
//  Observable.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/06/23.
//

import Foundation

final class Observable<T> {
    typealias Handler = (T) -> Void
    
    var value: T {
        didSet { handler?(value) }
    }
    
    var handler: Handler?
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(handler: Handler?) {
        self.handler = handler
        handler?(value)
    }
}
