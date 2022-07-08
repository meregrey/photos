//
//  ImageLoadable.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/06/23.
//

import UIKit.UIImage

protocol ImageLoadable {
    func loadImages(from urls: [URL]) async
}
