//
//  ImageLoadable.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/06/23.
//

import Foundation

protocol ImageLoadable {
    func loadImage(for url: URL, completion: @escaping () -> Void)
}
